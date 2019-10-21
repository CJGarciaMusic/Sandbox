function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "8/8/2019"
    return "Create Tempo Marking", "Create Tempo Marking", "Creates a custom tempo marking"
end

function place_expression(exp_text, exp_id, list_id)
    local measure= finale.FCMeasure()
    local music_region = finenv.Region()
    local first_measure = music_region:GetStartMeasure()
    measure:Load(first_measure)
    local exps = measure:CreateExpressions()
    local count = 0
    for exp in each(exps) do
        local ted = exp:CreateTextExpressionDef()
        if ted ~= nil then
            local ted_str = ted:CreateTextString()
            if string.match(ted_str.LuaString, exp_text) then
                count = count + 1
            end
        end
    end
    if count > 0 then
        return
    else
        local and_expression=finale.FCExpression()
        local region = finenv.Region()
        and_expression:SetID(exp_id)
        region:SetFullDocument()
        if region:CalcStaffSpan() == 1 then
            and_expression:SetScoreAssignment(true)
            local and_cell = finale.FCCell(first_measure, 1)
            and_expression:SaveNewToCell(and_cell)
        else
            for addstaff = region:GetStartStaff(), region:GetEndStaff() do
                local staff_num = finale.FCStaffList()
                staff_num:SetMode(finale.SLMODE_CATEGORY_SCORE)
                staff_num:Load(list_id)
                and_expression:SetPartAssignment(true)
                if staff_num:IncludesStaff(addstaff) then
                    and_expression:SetScoreAssignment(true)
                    local and_cell = finale.FCCell(first_measure, addstaff)
                    and_expression:SaveNewToCell(and_cell)
                end    
            end
        end
        -- local staff_num = finale.FCStaffList()
        -- staff_num:SetMode(finale.SLMODE_CATEGORY_SCORE)
        -- staff_num:Load(list_id)
        -- if staff_num:IncludesStaff(-1) then
        --     local and_cell = finale.FCCell(first_measure, 1)
        --     and_expression:SaveNewToCell(and_cell)
        -- end
    end
end

local function create_expression(text, category, staff_list)
    local exp_ted = finale.FCTextExpressionDef()
    local exp_str = finale.FCString()
    exp_str.LuaString = text
    exp_ted:SaveNewTextBlock(exp_str)
    local and_descriptionstr = finale.FCString()
    and_descriptionstr.LuaString = "Tempo Marking"
    exp_ted:SetDescription(and_descriptionstr)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(category)
    exp_ted:AssignToCategory(cat_def)
    exp_ted:SetUseCategoryPos(true)
    exp_ted:SetBreakMMRest(false)
    exp_ted:SaveNew()
    local item_no = exp_ted:GetItemNo()
    place_expression(text, item_no, staff_list)
end

local function find_expression(exp_text, cat_id, staff_id)
    local theID = 0
    local teds = finale.FCTextExpressionDefs()
    teds:LoadAll()
    for ted in each(teds) do
        if ted.CategoryID == cat_id then
            local ted_str = ted:CreateTextString()
            ted_str:TrimEnigmaTags()
            local exp_str = finale.FCString()
            exp_str.LuaString = exp_text
            exp_str:TrimEnigmaTags()
            if string.match(ted_str.LuaString, exp_str.LuaString) then
                theID = ted:GetItemNo()
            end
        end
    end
    if theID == 0 then
        create_expression(exp_text, cat_id, staff_id)
    else
        place_expression(exp_text, theID, staff_id)
    end
end

function create_tempo(tempo_text, beat_duration, beat_number, parenthetical_bool)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(2)
    local staff_id = cat_def:GetStaffListID()
    local fonti = cat_def:CreateTextFontInfo()
    cat_def:GetMusicFontInfo(fonti)
    local music_font = "^fontMus"..fonti:CreateEnigmaString(finale.FCString()).LuaString
    cat_def:GetTextFontInfo(fonti)
    local text_font = "^fontTxt"..fonti:CreateEnigmaString(finale.FCString()).LuaString
    cat_def:GetNumberFontInfo(fonti)
    local number_font = "^fontNum"..fonti:CreateEnigmaString(finale.FCString()).LuaString
    local user_text = tempo_text
    local user_duration = beat_duration
    local user_number = beat_number
    local user_parentheses = parenthetical_bool
    local start_parentheses = "("
    local end_parentheses = text_font..")"

    if user_text ~= "" then
        user_text = text_font..user_text
    end
    
    if user_duration ~= "" then
        user_duration = music_font..user_duration
    end
    
    if user_number ~= "" then
        user_number = number_font.." = "..user_number
    end

    if user_parentheses == false then
        if user_text:sub(-1) == " " then
            start_parentheses = ""
        else
            start_parentheses = " "
        end
        end_parentheses = ""
    end
    
    local full_string = user_text..start_parentheses..user_duration..user_number..end_parentheses
    find_expression(full_string, 2, staff_id)
end

function parse_tempo(the_string)
    local tempo_text = ""
    local beat_duration = ""
    local beat_number = ""
    local parenthetical_bool = false
    if (string.match(the_string, "%(?[qQhHwWeEsSxX][.]?%s?=%s?%d+%s?[%-–—]?%s?%d+%)?")) then
        local new_string = string.find(the_string, "%(?[qQhHwWeEsSxX][.]?%s?=%s?%d+%)?")
        if (new_string) > 1 then
            tempo_text = the_string:sub(1, (new_string - 1))
        else
            tempo_text = ""
        end
        local metronome_text = the_string:sub(new_string)
        if string.find(metronome_text, "%(") then
            parenthetical_bool = true
        end
        if string.find(metronome_text, "[qQhHwWeEsSxX][.]?") then
            beat_duration = metronome_text:sub(string.find(metronome_text, "[qQhHwWeEsSxX][.]?"))
        end
        if string.find(metronome_text, "%d+%s?[%-–—]?%s?%d+") then
            beat_number = metronome_text:sub(string.find(metronome_text, "%d+%s?[%-–—]?%s?%d+"))
        end
    else
        if string.match(the_string, "%a*") then
            tempo_text = the_string
        end
    end
    create_tempo(tempo_text, beat_duration, beat_number, parenthetical_bool)
end

function user_input(display_type)
    local input_dialog = finenv.UserValueInput()
    input_dialog:SetTypes("String")
    input_dialog:SetDescriptions("Pleaes Enter Your "..display_type.."Text")
    local returnvalues = input_dialog:Execute()

    if returnvalues ~= nil then
        if returnvalues[1] ~= "" then
            if display_type == "Tempo" then
                parse_tempo(returnvalues[1], display_type)
            end
        end
    end
end

user_input("Tempo")