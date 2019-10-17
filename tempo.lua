local function place_expression(exp_text, exp_id)
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
            and_expression:SetStaffListID(1)
            and_expression:SetVisible(true)
            and_expression:SetMeasurePos(0)
            and_expression:SetScaleWithEntry(false)
            and_expression:SetLayerAssignment(1)
            and_expression:SetPartAssignment(true)
            and_expression:SetScoreAssignment(true)
            and_expression:SetPlaybackLayerAssignment(1)
            and_expression:SetID(exp_id)
            local and_cell = finale.FCCell(first_measure,1)
            and_expression:SaveNewToCell(and_cell) 
    end
end

local function create_expression(text, category)
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
    place_expression(text, item_no)
    print(text, item_no)
end

local function find_expression(exp_text, cat_id)
    local theID = 0
    local teds = finale.FCTextExpressionDefs()
    teds:LoadAll()
    for ted in each(teds) do
        local ted_str = ted:CreateTextString()
        if string.match(ted_str.LuaString, exp_text) then
            theID = ted:GetItemNo()
        end
    end
    if theID == 0 then
        create_expression(exp_text, cat_id)
    else
        place_expression(exp_text, theID)
    end
end

function create_tempo(tempo_text, beat_duration, beat_number, parenthetical_bool)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(2)
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
    local start_parentheses = " ("
    local end_parentheses = text_font..")"

    if user_text ~= "" then
        user_text = text_font..user_text
    end
    print(user_duration)
    if user_duration ~= 1 then
        if user_duration == 2 then
            user_duration = music_font.."w"
        elseif user_duration == 3 then
            user_duration = music_font.."h"
        elseif user_duration == 4 then
            user_duration = music_font.."q"
        elseif user_duration == 5 then
            user_duration = music_font.."e"
        elseif user_duration == 6 then
            user_duration = music_font.."x"
        elseif user_duration == 7 then
            user_duration = music_font.."h."
        elseif user_duration == 8 then
            user_duration = music_font.."q."
        elseif user_duration == 9 then
            user_duration = music_font.."e."
        elseif user_duration == 10 then
            user_duration = music_font.."x."
        end
    end
    
    if user_number ~= "" then
        user_number = number_font.." = "..user_number
    end

    if user_parentheses == false then
        start_parentheses = " "
        end_parentheses = ""
    end
    
    local full_string = user_text..start_parentheses..user_duration..user_number..end_parentheses
    find_expression(full_string, 2)
end

function tempo_display()
    local tempo_input = finenv.UserValueInput()
    tempo_input:SetTypes("String", "NumberedList", "String", "Boolean")
    tempo_input:SetDescriptions("Tempo Text", "MM", "Beats Per Minute", "Use Parentheses?")
    tempo_input:SetLists(nil, {"Select...", "Whole Note", "Half Note", "Quarter Note", "Eighth Note", "Sixteenth Note", "Dotted Half Note", "Dotted Quarter Note", "Dotted Eighth Note", "Dotted Sixteenth Note"}, nil, nil)
    local returnvalues = tempo_input:Execute()

    if returnvalues ~= nil then
        create_tempo(returnvalues[1], returnvalues[2], returnvalues[3], returnvalues[4], returnvalues[5])
    end
end

tempo_display()