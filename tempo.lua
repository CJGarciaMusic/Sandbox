function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "8/8/2019"
    return "Create Tempo Marking", "Create Tempo Marking", "Creates a custom tempo marking"
end

-- function place_expression(exp_text, exp_id, list_id)
--     local measure= finale.FCMeasure()
--     local music_region = finenv.Region()
--     local first_measure = music_region:GetStartMeasure()
--     local first_pos = music_region:GetStartMeasurePos()
--     if list_id ~= nil then
--     local measure= finale.FCMeasure()
--     local music_region = finenv.Region()
--     local first_measure = music_region:GetStartMeasure()
--     local first_pos = music_region:GetStartMeasurePos()
--     measure:Load(first_measure)
--     local exps = measure:CreateExpressions()
--     local count = 0
--     for exp in each(exps) do
--         local ted = exp:CreateTextExpressionDef()
--         if ted ~= nil then
--             local ted_str = ted:CreateTextString()
--             if string.match(ted_str.LuaString, exp_text) then
--                 count = count + 1
--             end
--         end
--     end
--     if count > 0 then
--         return
--     else
--         local and_expression=finale.FCExpression()
--         local region = finenv.Region()
--         and_expression:SetID(exp_id)
--         region:SetFullDocument()
--         if region:CalcStaffSpan() == 1 then
--             and_expression:SetScoreAssignment(true)
--             local and_cell = finale.FCCell(first_measure, 1)
--             and_expression:SaveNewToCell(and_cell)
--         else
--             for addstaff = region:GetStartStaff(), region:GetEndStaff() do
--                 local staff_num = finale.FCStaffList()
--                 staff_num:SetMode(finale.SLMODE_CATEGORY_SCORE)
--                 staff_num:Load(list_id)
--                 and_expression:SetPartAssignment(true)
--                 if staff_num:IncludesStaff(addstaff) then
--                     and_expression:SetScoreAssignment(true)
--                     local and_cell = finale.FCCell(first_measure, addstaff)
--                     and_expression:SaveNewToCell(and_cell)
--                 end    
--             end
--         end
--         -- local staff_num = finale.FCStaffList()
--         -- staff_num:SetMode(finale.SLMODE_CATEGORY_SCORE)
--         -- staff_num:Load(list_id)
--         -- if staff_num:IncludesStaff(-1) then
--         --     local and_cell = finale.FCCell(first_measure, 1)
--         --     and_expression:SaveNewToCell(and_cell)
--         -- end
--     end
-- end

local text_expression = {}

function add_text_expression(staff_num, measure_num, measure_pos)
    local del_region = finenv.Region()
    del_region:SetStartStaff(staff_num)
    del_region:SetEndStaff(staff_num)
    del_region:SetStartMeasure(measure_num)
    del_region:SetEndMeasure(measure_num)
    del_region:SetStartMeasurePos(measure_pos)
    del_region:SetEndMeasurePos(measure_pos)
    local expressions = finale.FCExpressions()
    expressions:LoadAllForRegion(del_region)
    for e in each(expressions) do
        if e.ID == text_expression[1] then
            e:DeleteData()
            return
        end
    end
    local add_expression = finale.FCExpression()
    add_expression:SetStaff(staff_num)
    add_expression:SetVisible(true)
    add_expression:SetMeasurePos(measure_pos)
    add_expression:SetScaleWithEntry(true)
    add_expression:SetPartAssignment(true)
    add_expression:SetScoreAssignment(true)
    add_expression:SetID(text_expression[1])
    local and_cell = finale.FCCell(measure_num, staff_num)
    add_expression:SaveNewToCell(and_cell)
end

local staff_list = {}

function get_tempo_staves()
    local item_num = 0
    local sll = finale.FCStaffListLookup()
    if (sll:LoadCategoryList(2)) then 
        local sl = finale.FCStaffList()
        sl:SetMode(finale.SLMODE_CATEGORY_SCORE)
        if sl:LoadFirst() then
            item_num = sl:GetItemNo()
            if (sl:IncludesTopStaff()) then
                table.insert(staff_list, 1)
            end
            local staves = finale.FCStaves()
            staves:LoadAll()
            for staff in each(staves) do
                if sl:IncludesStaff(staff:GetItemNo()) then
                    table.insert(staff_list, staff:GetItemNo())
                end
            end
        end
    end
end

function add_tempo(measure_num)
    local count = 0
    local add_expression = finale.FCExpression()
    for key, value in pairs(staff_list) do
        add_expression:SetPartAssignment(false)
        add_expression:SetScoreAssignment(true)
        add_expression:SetStaff(value)
        add_expression:SetStaffGroupID(1)
        add_expression:SetStaffListID(1)
        add_expression:SetVisible(true)
        add_expression:SetID(text_expression[1])
        local and_cell = finale.FCCell(measure_num, value)
        add_expression:SaveNewToCell(and_cell)
        count = count + 1
    end
    add_expression:SetPartAssignment(true)
    add_expression:SetScoreAssignment(false)
    add_expression:SetStaff(-1)
    add_expression:SetStaffGroupID(1)
    add_expression:SetStaffListID(1)
    add_expression:SetVisible(true)
    add_expression:SetID(text_expression[1])
    local and_cell = finale.FCCell(measure_num, -1)
    add_expression:SaveNewToCell(and_cell)
end

function text_expression_region(note_range)
    local music_region = finenv.Region()
    local range_settings = {}
    
    for addstaff = music_region:GetStartStaff(), music_region:GetEndStaff() do
        music_region:SetStartStaff(addstaff)
        music_region:SetEndStaff(addstaff)

        local measure_pos_table = {}
        local measure_table = {}
        
        local count = 0
        
        for noteentry in eachentrysaved(music_region) do
            if noteentry:IsNote() then
                table.insert(measure_pos_table, noteentry:GetMeasurePos())
                table.insert(measure_table, noteentry:GetMeasure())
                count = count + 1
            end
        end

        local start_pos = measure_pos_table[1]
        local start_measure = measure_table[1]
        if (note_range == "Region Start") or (start_pos == nil) then
            start_pos = music_region:GetStartMeasurePos()
            start_measure = music_region:GetStartMeasure()
        elseif note_range == "Tempo" then
            start_measure = music_region:GetStartMeasure()
            start_pos = 0
        end
        local end_pos = measure_pos_table[count]
        local end_measure = measure_table[count]
        if (note_range == "Region End") or (end_pos == nil) then
            end_measure = music_region:GetEndMeasure()
            end_pos = music_region:GetEndMeasurePos()
            if end_pos > 1000000 then
                local get_time = finale.FCMeasure()
                get_time:Load(end_measure)
                local new_right_end = get_time:GetTimeSignature()
                local beat = new_right_end:GetBeats()
                local duration = new_right_end:GetBeatDuration()
                end_pos = beat * duration
            end
        end

        if count == 1 then
            end_pos = music_region:GetEndMeasurePos() 
        end
    
        range_settings[addstaff] = {addstaff, start_measure, end_measure, start_pos, end_pos}
    end

    for key, value in pairs(range_settings) do
        if (note_range == "Start") or (note_range == "Region Start") then
            addTextExpression(value[1], value[2], value[4])
        end
        if (note_range == "End") or (note_range == "Region End") then
            addTextExpression(value[1], value[3], value[5])
        end
        if note_range == "Tempo" then
            get_tempo_staves()
            add_tempo(value[2])
        end
    end
end

local function create_text_expression(text, category)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(category)
    local fonti = cat_def:CreateTextFontInfo()
    local text_font = "^fontTxt"..fonti:CreateEnigmaString(finale.FCString()).LuaString
    cat_def:GetNumberFontInfo(fonti)
    local full_string = text_font..text

    local exp_ted = finale.FCTextExpressionDef()
    local exp_str = finale.FCString()
    exp_str.LuaString = full_string
    exp_ted:SaveNewTextBlock(exp_str)
    local and_descriptionstr = finale.FCString()
    and_descriptionstr.LuaString = text
    exp_ted:SetDescription(and_descriptionstr)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(category)
    exp_ted:AssignToCategory(cat_def)
    exp_ted:SetUseCategoryPos(true)
    exp_ted:SaveNew()
    local item_no = exp_ted:GetItemNo()
    table.insert(text_expression, item_no)
end

local function create_tempo_expression(text, category)
    local exp_ted = finale.FCTextExpressionDef()
    local exp_str = finale.FCString()
    exp_str.LuaString = text
    exp_ted:SaveNewTextBlock(exp_str)
    local and_descriptionstr = finale.FCString()
    local description_text = ""
    and_descriptionstr.LuaString = description_text
    exp_ted:SetDescription(and_descriptionstr)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(category)
    exp_ted:AssignToCategory(cat_def)
    exp_ted:SetUseCategoryPos(true)
    exp_ted:SaveNew()
    local item_no = exp_ted:GetItemNo()
    table.insert(text_expression, item_no)
end

function create_tempo_string(tempo_text, beat_duration, beat_number, parenthetical_bool)
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
    create_tempo_expression(full_string, 2)
end

local function find_text_expression(exp_text, cat_id)
    local theID = {}
    local teds = finale.FCTextExpressionDefs()
    teds:LoadAll()
    for ted in each(teds) do
        if ted.CategoryID == cat_id then
            local ted_str = ted:CreateTextString()
            ted_str:TrimEnigmaTags()
            if ted_str.LuaString == exp_text then
                table.insert(theID, ted:GetItemNo())
            end
        end
    end
    if theID[1] == nil then
        if cat_id ~= 2 then
            create_text_expression(exp_text, cat_id, staff_id)
        else
            parse_tempo(exp_text, cat_id)
        end
    else
        table.insert(text_expression, theID[1])
    end
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
    create_tempo_string(tempo_text, beat_duration, beat_number, parenthetical_bool)
end

function user_input(display_type)
    local input_dialog = finenv.UserValueInput()
    input_dialog:SetTypes("String")
    input_dialog:SetDescriptions("Pleaes Enter Your "..display_type.." Text")
    local returnvalues = input_dialog:Execute()

    if returnvalues ~= nil then
        if returnvalues[1] ~= "" then
            if display_type == "Tempo" then
                parse_tempo(returnvalues[1], 2)
                text_expression_region("Tempo")
            elseif display_type == "Expressive" then
                find_text_expression(returnvalues[1], 4)
                text_expression_region("Start")
            elseif display_type == "Technique" then
                find_text_expression(returnvalues[1], 5)
                text_expression_region("Start")
            end
        end
    end
end

user_input("Tempo")