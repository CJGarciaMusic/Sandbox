local function adjustHairpins(addstaff, start_meas, end_meas, start_pos, end_pos, smart_shape)
    local ssmm = finale.FCSmartShapeMeasureMarks()
    ssmm:LoadAllForRegion(finenv.Region(), true) 
    for mark in each(ssmm) do
        local smartshape = mark:CreateSmartShape()
        if smartshape:IsHairpin() then
            local music_reg = finenv.Region()
            music_reg:SetStartStaff(addstaff)
            music_reg:SetEndStaff(addstaff)

            local has_left_dyn = 0
            local left_x_value = 0
            music_reg:SetStartMeasure(start_meas)
            music_reg:SetEndMeasure(start_meas)
            music_reg:SetStartMeasurePos(start_pos)
            music_reg:SetEndMeasurePos(start_pos)

            local left_expressions = finale.FCExpressions()
            left_expressions:LoadAllForRegion(music_reg)

            local left_add_offset = 0

            for le in each(left_expressions) do
                local create_def = le:CreateTextExpressionDef()
                local cd = finale.FCCategoryDef()
                if cd:Load(create_def:GetCategoryID()) then
                    if string.find(cd:CreateName().LuaString, "Dynamic") then
                        has_left_dyn = 1
                        local text_met = finale.FCTextMetrics()
                        text_met:LoadString(create_def:CreateTextString(), create_def:CreateTextString():CreateLastFontInfo(), 100)
                        left_x_value = ((text_met:CalcWidthEVPUs() - 1027) / 2) + (le:GetHorizontalPos())
                    end
                end
            end

            local leftseg = smartshape:GetTerminateSegmentLeft()
            leftseg:SetMeasure(start_meas)
            leftseg.Staff = addstaff
            leftseg:SetCustomOffset(false)
            leftseg:SetEndpointOffsetX(left_x_value)
            leftseg:SetMeasurePos(music_reg:GetStartMeasurePos())

            local has_right_dyn = 0
            music_reg:SetStartMeasure(end_meas)
            music_reg:SetEndMeasure(end_meas)
            music_reg:SetStartMeasurePos(end_pos)
            music_reg:SetEndMeasurePos(end_pos)

            local right_expressions = finale.FCExpressions()
            right_expressions:LoadAllForRegion(music_reg)
            
            for re in each(right_expressions) do
                local create_def = re:CreateTextExpressionDef()
                local cd = finale.FCCategoryDef()
                if cd:Load(create_def:GetCategoryID()) then
                    if string.find(cd:CreateName().LuaString, "Dynamic") then
                        has_right_dyn = 1
                        local text_met = finale.FCTextMetrics()
                        text_met:LoadString(create_def:CreateTextString(), create_def:CreateTextString():CreateLastFontInfo(), 100)
                        right_x_value = (0 - (text_met:CalcWidthEVPUs() - 1000) / 2) + (re:GetHorizontalPos())
                    end
                end
            end

            local rightseg = smartshape:GetTerminateSegmentRight()
            rightseg:SetMeasure(end_meas)
            rightseg.Staff = addstaff
            rightseg:SetCustomOffset(false)
            if right_x_value == 0 then
                rightseg:SetEndpointOffsetX(0)
            else
                rightseg:SetEndpointOffsetX(right_x_value)
            end
            rightseg:SetMeasurePos(music_reg:GetEndMeasurePos())
            smartshape:Save()
        end
    end
end


local function setAdjustHairpinRange()
    local music_region = finenv.Region()
    local start_meas = music_region:GetStartMeasure()
    local end_meas = music_region:GetEndMeasure()
    for addstaff = music_region:GetStartStaff(), music_region:GetEndStaff() do
        music_region:SetStartStaff(addstaff)
        music_region:SetEndStaff(addstaff)
        
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
        adjustHairpins(addstaff, start_meas, end_meas, start_pos, end_pos, smart_shape)
    end
end

setAdjustHairpinRange()