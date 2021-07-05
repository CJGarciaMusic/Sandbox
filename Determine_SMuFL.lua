function check_SMuFL(what_to_check)
    local font_check = {"Finale Ash", "Finale Broadway", "Finale Engraver", "Finale Jazz", "Finale Maestro"}
    local is_SMuFL = false
    if what_to_check ~= nil then
        if what_to_check[1] == "Expression" then
            local cd = finale.FCCategoryDef()
            if cd:Load(what_to_check[2]) then
                local fontinfo = finale.FCFontInfo()
                if cd:GetMusicFontInfo(fontinfo) then
                    for k, v in pairs(font_check) do
                        if fontinfo:GetName() == v then
                            is_SMuFL = true
                            break
                        end
                    end
                end
            end
        end
    else
        local fontinfo = finale.FCFontInfo()
        if fontinfo:LoadFontPrefs(finale.FONTPREF_MUSIC) then
            for k, v in pairs(font_check) do
                if fontinfo:GetName() == v then
                    is_SMuFL = true
                    break
                end
            end
        end
    end  

    return is_SMuFL
end

local first_expression = {}

function find_dynamic(glyph_nums, table_name, description_text, uses_smufl)
    local matching_glyphs = {}
    local exp_defs = finale.FCTextExpressionDefs()
    local exp_def = finale.FCTextExpressionDef()
    exp_defs:LoadAll()
    for exp in each(exp_defs) do
        if exp:GetCategoryID() == 1 then
            local exp_string = finale.FCString()
            exp_string.LuaString = ""
            for key, value in pairs(glyph_nums) do
                exp_string:AppendCharacter(value)
            end
            local current_string = exp:CreateTextString()
            current_string:TrimEnigmaTags()
            if uses_smufl then
                if string.len(exp_string.LuaString) > 3 then
                    if ((current_string:GetCharacterAt(3) == glyph_nums[2]) and (current_string:GetCharacterAt(0) == glyph_nums[1])) then
                        table.insert(matching_glyphs, exp:GetItemNo())
                    end
                else 

                    if (current_string:GetCharacterAt(0) == glyph_nums[1]) and (string.len(current_string.LuaString) == 3) then
                        table.insert(matching_glyphs, exp:GetItemNo())
                    end
                end
            else
                if string.len(exp_string.LuaString) > 1 then
                    if ((current_string:GetCharacterAt(1) == glyph_nums[2]) and (current_string:GetCharacterAt(0) == glyph_nums[1])) then
                        table.insert(matching_glyphs, exp:GetItemNo())
                    end
                else
                    if (current_string:GetCharacterAt(0) == glyph_nums[1]) and (string.len(current_string.LuaString) == 1) then
                        table.insert(matching_glyphs, exp:GetItemNo()) 
                    end
                end
            end
        end
    end
    if matching_glyphs[1] == nil then
        create_dynamic(glyph_nums, table_name, description_text)
    else
        exp_def:Load(matching_glyphs[1])
        table.insert(table_name, exp_def:GetItemNo())  
    end
end

local dyn_smufl = check_SMuFL({"Expression", 1})

if dyn_smufl then
    find_dynamic({58658}, first_expression, "forte (velocity = 88)", dyn_smufl)
else
    find_dynamic({102}, first_expression, "forte (velocity = 88)", dyn_smufl)
end

-- 58673 fortissississimo (velocity = 127)
-- 58672 fortississimo (velocity = 114)
-- 58671 fortissimo (velocity = 101)
-- 58658 forte (velocity = 88)
-- 58669 mezzo forte (velocity = 75)
-- 58668 mezzo piano (velocity = 62)
-- 58656 piano (velocity = 49)
-- 58667 pianissimo (velocity = 36)
-- 58666 pianississimo (velocity = 23)
-- 58665 pianissississimo (velocity = 10)
-- 58676 forte piano
-- 58677 forzando
-- 58678 sforzando 
-- 58683 sforzato
-- 58681 sforzando piano
-- 58680 sforzato pianissimo
-- 58679 sforzato piano
-- 58659 rinforzando
-- 115 subito piano (velocity = 49)
-- 115 subito piano (velocity = 49) 
-- 58662 pianissississimo (velocity = 10) (Copy)
-- 58689 pianissississimo (velocity = 10) (Copy)