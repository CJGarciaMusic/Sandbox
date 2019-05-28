local function createCrescendo(staff, measure_start, measure_end, leftpos, rightpos)    
    local smartshape = finale.FCSmartShape()
    smartshape.ShapeType = finale.SMARTSHAPE_CRESCENDO
    smartshape.EntryBased = false
    smartshape.MakeHorizontal = true
    smartshape.BeatAttached= true
    smartshape.PresetShape = true
    smartshape.Visible = true
    smartshape.LineID = 3

    if rightpos > 1000000 then
        local get_time = finale.FCMeasure()
        get_time:Load(measure_end)
        local new_right_end = get_time:GetTimeSignature()
        local beat = new_right_end:GetBeats()
        local duration = new_right_end:GetBeatDuration()
        rightpos = beat * duration
    end

    local staff_pos = {}

    local music_reg = finenv.Region()
    music_reg:SetStartStaff(staff)
    music_reg:SetEndStaff(staff)

    for noteentry in eachentrysaved(music_reg) do
        if noteentry:IsNote() then
            for note in each(noteentry) do
                table.insert(staff_pos, note:CalcStaffPosition())
            end
        end
    end

    local has_left_dyn = 0
    local left_x_value = 0
    music_reg:SetStartMeasure(measure_start)
    music_reg:SetEndMeasure(measure_start)
    music_reg:SetStartMeasurePos(leftpos)
    music_reg:SetEndMeasurePos(leftpos)

    local left_expressions = finale.FCExpressions()
    left_expressions:LoadAllForRegion(music_reg)

    local left_add_offset = 0

    for le in each(left_expressions) do
        local create_def = le:CreateTextExpressionDef()
        local cd = finale.FCCategoryDef()
        if cd:Load(create_def:GetCategoryID()) then
            if string.find(cd:CreateName().LuaString, "Dynamic") then
                has_left_dyn = 1
                if string.find(create_def:CreateTextString().LuaString, ")ë") then
                    left_x_value = 68 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")ì") then
                    left_x_value = 54 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")Ä") then
                    left_x_value = 45 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")f") then
                    left_x_value = 36 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")F") then
                    left_x_value = 54 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")P") then
                    left_x_value = 54 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")p") then
                    left_x_value = 36 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")¹") then
                    left_x_value = 54 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")¸") then
                    left_x_value = 68 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")¯") then
                    left_x_value = 86 + (le:GetHorizontalPos())
                    left_add_offset = le:GetVerticalPos()
                end
            end
        end
    end
     
    local has_right_dyn = 0
    music_reg:SetStartMeasure(measure_end)
    music_reg:SetEndMeasure(measure_end)
    music_reg:SetStartMeasurePos(rightpos)
    music_reg:SetEndMeasurePos(rightpos)

    local right_expressions = finale.FCExpressions()
    right_expressions:LoadAllForRegion(music_reg)
    
    local right_add_offset = 0

    for re in each(right_expressions) do
        local create_def = re:CreateTextExpressionDef()
        local cd = finale.FCCategoryDef()
        if cd:Load(create_def:GetCategoryID()) then
            if string.find(cd:CreateName().LuaString, "Dynamic") then
                has_right_dyn = 1
                if string.find(create_def:CreateTextString().LuaString, ")ë") then
                    right_x_value = -76 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")ì") then
                    right_x_value = -63 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")Ä") then
                    right_x_value = -52 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")f") then
                    right_x_value = -40 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")F") then
                    right_x_value = -50 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")P") then
                    right_x_value = -54 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")p") then
                    right_x_value = -40 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")¹") then
                    right_x_value = -60 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")¸") then
                    right_x_value = -80 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
                if string.find(create_def:CreateTextString().LuaString, ")¯") then
                    right_x_value = -98 + (re:GetHorizontalPos())
                    right_add_offset = re:GetVerticalPos()
                end
            end
        end
    end

    local additional_offset = 0
    local base_line_offset = 16
    local entry_offset  = -72

    local get_offsets = finale.FCExpressions()
    get_offsets:LoadAllForRegion(music_reg)

    for offset in each(get_offsets) do
        local create_def = offset:CreateTextExpressionDef()
        local cd = finale.FCCategoryDef()
        if cd:Load(create_def:GetCategoryID()) then
            if string.find(cd:CreateName().LuaString, "Dynamic") then
                base_line_offset =  create_def:GetVerticalBaselineOffset()
                entry_offset = create_def:GetVerticalEntryOffset()
            end
        end
    end

    if left_add_offset <= right_add_offset then
        additional_offset = left_add_offset
    else
        additional_offset = right_add_offset
    end

    table.sort(staff_pos)

    if staff_pos[1] <= -11 then
        y_value = ((staff_pos[1] * 12) + entry_offset) + additional_offset
    else
        y_value = (base_line_offset * -12) + additional_offset
    end

    if has_left_dyn == 0 then
        left_x_value = 0
    end

    local leftseg = smartshape:GetTerminateSegmentLeft()
    leftseg:SetMeasure(measure_start)
    leftseg.Staff = staff
    leftseg:SetCustomOffset(false)
    leftseg:SetEndpointOffsetY(y_value)
    leftseg:SetEndpointOffsetX(left_x_value)
    leftseg:SetMeasurePos(leftpos)


    if has_right_dyn == 0 then
        right_x_value = 0
    end

    local rightseg = smartshape:GetTerminateSegmentRight()
    rightseg:SetMeasure(measure_end)
    rightseg.Staff = staff
    rightseg:SetCustomOffset(false)
    if right_x_value == 0 then
        rightseg:SetEndpointOffsetX(0)
    else
        rightseg:SetEndpointOffsetX(right_x_value)
    end
    rightseg:SetEndpointOffsetY(y_value)
    rightseg:SetMeasurePos(rightpos)
    smartshape:SaveNewEverything(nil, nil)
end

local function setRange()
    local music_region = finenv.Region()
    local start_meas = music_region.StartMeasure
    local end_meas = music_region.EndMeasure
    local measure_pos_table = {}

    local count = 0
    
    for noteentry in eachentry(music_region) do
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

    for addstaff = music_region:GetStartStaff(), music_region:GetEndStaff() do
        createCrescendo(addstaff, start_meas, end_meas, start_pos, end_pos)
    end
end

setRange()