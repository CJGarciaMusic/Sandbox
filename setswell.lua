-- function setSwellRange(smart_shape1, smart_shape2)
--     local music_region = finenv.Region()
--     local measure_pos_table = {}
--     local measure_table = {}

--     local count = 0
    
--     for noteentry in eachentry(music_region) do
--         if noteentry:IsNote() then
--             table.insert(measure_pos_table, noteentry:GetMeasurePos())
--             table.insert(measure_table, noteentry:GetMeasure())
--             count = count + 1
--         end
--     end
--     local start_meas = measure_table[1]
--     local end_meas = measure_table[count]
--     local start_pos = measure_pos_table[1]
--     local end_pos = measure_pos_table[count]

--     local half_way_meas = finenv.Region()
--     half_way_meas:SetStartMeasure(start_meas)
--     half_way_meas:SetEndMeasure(end_meas)

--     local half_way_region = finenv.Region()
--     half_way_region:SetStartMeasurePos(start_pos)
--     half_way_region:SetEndMeasurePos(end_pos)

--     local half_way_pos = half_way_region:CalcDuration()

--     local get_time = finale.FCMeasure()
--     get_time:Load(start_meas)
--     local signature = get_time:GetTimeSignature()
--     local beat = signature:GetBeats()
--     local duration = signature:GetBeatDuration()
--     local one_measure = beat * duration
--     local half_measure = math.floor((half_way_meas:CalcMeasureSpan() / 2) + 0.5)
--     local half_point = math.floor((((half_measure * one_measure) + 0.5) - math.floor(half_way_pos:CalcDuration() / 2) - 0.5)) - duration

--     if count < 2 then
--         end_pos = music_region:GetEndMeasurePos() 
--     end

--     for addstaff = music_region:GetStartStaff(), music_region:GetEndStaff() do
--         createHairpin(addstaff, start_meas, half_measure, start_pos, half_point, smart_shape1, -12)
--         createHairpin(addstaff, half_measure, end_meas, half_point, end_pos, smart_shape2, 12)
--     end
-- end