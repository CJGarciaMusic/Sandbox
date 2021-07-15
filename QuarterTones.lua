function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 MakeMusic"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "7/15/2020"
    finaleplugin.CategoryTags = "Expression"
    return "Quarter Tones", "Quarter Tones", "Creates quarter tones for the notes in the selected region"
end

function check_SMuFL(what_to_check)
    local font_check = {"Maestro", "Engraver Font Set", "Broadway Copyist", "Jazz"}
    local is_SMuFL = true
    if what_to_check ~= nil then
        if what_to_check[1] == "Expression" then
            local cd = finale.FCCategoryDef()
            if cd:Load(what_to_check[2]) then
                local fontinfo = finale.FCFontInfo()
                if cd:GetMusicFontInfo(fontinfo) then
                    for k, v in pairs(font_check) do
                        if fontinfo:GetName() == getUsedFontName(v) then
                            is_SMuFL = false
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
                if fontinfo:GetName() == getUsedFontName(v) then
                    is_SMuFL = false
                    break
                end
            end
        end
    end  

    return is_SMuFL
end

function getUsedFontName(standard_name)
    local font_name = standard_name
    if string.find(os.tmpname(), "/") then
        font_name = standard_name
    elseif string.find(os.tmpname(), "\\") then
        font_name = string.gsub(standard_name, "%s", "")
    end
    return font_name
end

local error_list = {}

function create_quarter_tone(qt_type)
    local pref_font = check_SMuFL(nil)
    
    local music_region = finenv.Region()

    for addstaff = music_region:GetStartStaff(), music_region:GetEndStaff() do
        music_region:SetStartStaff(addstaff)
        music_region:SetEndStaff(addstaff)
        for noteentry in eachentrysaved(music_region) do
            if noteentry.Count > 1 then
                local staff_name = staff:CreateFullNameString()
                staff_name:TrimEnigmaTags()
                local measure_num = noteentry:GetMeasure()
                table.insert(error_list, "Staff: "..staff_name.LuaString.." Measure: "..measure_num)
            else
                for note in each(noteentry) do
                    local accidentalmod = finale.FCAccidentalMod()
                    if pref_font then
                        -- insert all SMuFL
                        
                        accidentalmod.CustomChar = 36
                    else
                        -- insert all non SMuFL
                        if qt_type == "Third Quarter Sharp" then
                            accidentalmod.CustomChar = 36
                        end
                        if qt_type == "Third Quarter Flat" then
                            accidentalmod.CustomChar = 245
                        end
                    end
                    accidentalmod:SaveAt(note)
                    note:SetAccidental(true)
                    note:SetAccidentalFreeze(true)
                end
            end
        end
    end
end


if #error_list > 0 then
    local full_string = ""
    for key, value in pairs(error_list) do
        full_string = full_string..value.."\n"
    end
    finenv.UI():AlertInfo(full_string, "Unable To Process The Following:")
end

-- create_quarter_tone("Third Quarter Sharp")

print(tonumber("E4A0"))