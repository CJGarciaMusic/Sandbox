local function createCrescendo(staff, measure_start, measure_end, leftpos, rightpos, endstem)
    
    if rightpos > 1000000 then
        local get_time = finale.FCMeasure()
        get_time:Load(measure_end)
        local new_right_end = get_time:GetTimeSignature()
        local beat = new_right_end:GetBeats()
        local duration = new_right_end:GetBeatDuration()
        rightpos = beat * duration
    end

    local staff_pos = {}


    for noteentry in eachentrysaved(finenv.Region()) do
        if noteentry:IsNote() then
            for note in each(noteentry) do
                table.insert(staff_pos, note:CalcStaffPosition())
            end
        end
    end

    local has_left_dyn = 0
    local left_x_value = 0
    local left_reg = finenv.Region()
    left_reg:SetStartStaff(staff)
    left_reg:SetEndStaff(staff)
    left_reg:SetStartMeasure(measure_start)
    left_reg:SetEndMeasure(measure_start)
    left_reg:SetStartMeasurePos(leftpos)
    left_reg:SetEndMeasurePos(leftpos)

    local expressions = finale.FCExpressions()
    expressions:LoadAllForRegion(left_reg)

    for e in each(expressions) do
        local create_def = e:CreateTextExpressionDef()
        if create_def:GetCategoryID() == 1 then
            has_left_dyn = 1
            if string.find(create_def:CreateTextString().LuaString, ")ë") then
                left_x_value = 68
            end
            if string.find(create_def:CreateTextString().LuaString, ")ì") then
                left_x_value = 54
            end
            if string.find(create_def:CreateTextString().LuaString, ")Ä") then
                left_x_value = 45
            end
            if string.find(create_def:CreateTextString().LuaString, ")f") then
                left_x_value = 36
            end
            if string.find(create_def:CreateTextString().LuaString, ")F") then
                left_x_value = 54
            end
            if string.find(create_def:CreateTextString().LuaString, ")P") then
                left_x_value = 54
            end
            if string.find(create_def:CreateTextString().LuaString, ")p") then
                left_x_value = 36
            end
            if string.find(create_def:CreateTextString().LuaString, ")¹") then
                left_x_value = 54
            end
            if string.find(create_def:CreateTextString().LuaString, ")¸") then
                left_x_value = 68
            end
            if string.find(create_def:CreateTextString().LuaString, ")¯") then
                left_x_value = 86
            end
        end
    end

    if has_left_dyn == 0 then
        left_x_value = 0
    end
    
    table.sort(staff_pos)
    
    if staff_pos[1] <= -11 then
        y_value = (staff_pos[1] * 12) - 54
    else
        y_value = -180
    end

    local smartshape = finale.FCSmartShape()
    smartshape.ShapeType = finale.SMARTSHAPE_CRESCENDO
    smartshape.EntryBased = false
    smartshape.MakeHorizontal = true
    smartshape.BeatAttached= true
    smartshape.PresetShape = true
    smartshape.Visible = true
    smartshape.LineID = 3

    local leftseg = smartshape:GetTerminateSegmentLeft()
    leftseg:SetMeasure(measure_start)
    leftseg.Staff = staff
    leftseg:SetCustomOffset(false)
    leftseg:SetEndpointOffsetY(y_value)
    leftseg:SetEndpointOffsetX(left_x_value)
    leftseg:SetMeasurePos(leftpos)
    
    
    local has_right_dyn = 0
    local right_reg = finenv.Region()
    right_reg:SetStartStaff(staff)
    right_reg:SetEndStaff(staff)
    right_reg:SetStartMeasure(measure_end)
    right_reg:SetEndMeasure(measure_end)
    right_reg:SetStartMeasurePos(rightpos)
    right_reg:SetEndMeasurePos(rightpos)

    expressions:LoadAllForRegion(right_reg)

    for e in each(expressions) do
        local create_def = e:CreateTextExpressionDef()
        if create_def:GetCategoryID() == 1 then
            has_right_dyn = 1
        end
    end

    if has_right_dyn ~= 0 then
        right_x_value = -18
    else
        right_x_value = 0
    end

    local rightseg = smartshape:GetTerminateSegmentRight()
    rightseg:SetMeasure(measure_end)
    rightseg.Staff = staff
    rightseg:SetCustomOffset(false)
    if right_x_value == 0 then
        if (endstem == true) then
            rightseg:SetEndpointOffsetX(27)
        else
            rightseg:SetEndpointOffsetX(0)
        end
    else
        rightseg:SetEndpointOffsetX(right_x_value)
    end
    rightseg:SetEndpointOffsetY(y_value)
    rightseg:SetMeasurePos(rightpos)
    smartshape:SaveNewEverything(NULL, NULL)
end

local music_region = finenv.Region()

for addstaff=1, music_region:CalcStaffSpan() do
    music_region:SetStartStaff(addstaff)
    music_region:SetEndStaff(addstaff)
    local measure_pos_table = {}

    local count = 0
    
    for noteentry in eachentrysaved(music_region) do
        if noteentry:IsNote() then
            table.insert(measure_pos_table, noteentry:GetMeasurePos())
            count = count + 1
        end
    end
    
    local start_pos = measure_pos_table[1]
    
    local end_pos = measure_pos_table[count]
    
    if count < 2 then
        end_pos = music_region:GetEndMeasurePos() 
    end
        
    local entry_table = {}
    
    local right_note_count = 0
    
    for noteentry in eachentrysaved(music_region) do
        if noteentry:IsNote() then
            table.insert(entry_table, noteentry:GetMeasurePos())
            right_note_count = right_note_count + 1
        end
    end

    local right_noteentry_cell = finale.FCNoteEntryCell(music_region.EndMeasure, addstaff)
    right_noteentry_cell:Load()
    
    local rightnoteentry = right_noteentry_cell:FindEntryStartPosition(entry_table[right_note_count], 1)
    
    local stem_up = rightnoteentry:CalcStemUp()
    createCrescendo(addstaff, music_region.StartMeasure, music_region.EndMeasure, start_pos, end_pos, stem_up)
end