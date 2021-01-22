function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 MakeMusic"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "7/15/2020"
    finaleplugin.CategoryTags = "Expression"
    return "Find Redundant Dynamics", "Find Redundant Dynamics", "Find the redundant dynamics in a selected region."
end

function get_beat_num(measure_num, measure_pos)
    local measure = finale.FCMeasure()
    measure:Load(measure_num)
    local time_sig = measure:GetTimeSignature()
    local beat_num = 0
    local beat_offset = time_sig:GetBeatDuration()
    local calc_beat = measure_pos + beat_offset
    if calc_beat == 0 then
        beat_num = 1
    else
        beat_num = calc_beat / beat_offset
    end
    return beat_num
end

local notification_table = ""

function find_redundant(staff_num)
    local staff = finale.FCStaff()
    staff:Load(staff_num)
    local staff_name = staff:CreateFullNameString()
    staff_name:TrimEnigmaTags()
    staff_name = staff_name.LuaString
    
    local music_region = finenv.Region()
    music_region:SetStartStaff(staff_num)
    music_region:SetEndStaff(staff_num)


    local expressions = finale.FCExpressions()
    expressions:LoadAllForRegion(music_region)

    local comparison_table = {}
    local measure_info_table = {}
    for exp in each(expressions) do
        local exp_def = exp:CreateTextExpressionDef()
        if exp_def:GetCategoryID() == 1 then
            table.insert(comparison_table, exp_def:GetTextID())
            table.insert(measure_info_table, "Measure "..exp:GetMeasure().." at beat "..get_beat_num(exp:GetMeasure(), exp:GetMeasurePos()))
        end
    end

    local report_string = ""

    for k, v in pairs(comparison_table) do
        if comparison_table[k + 1] ~= nil then
            if v == comparison_table[k + 1] then
                report_string = measure_info_table[k].."\n"..measure_info_table[k + 1].."\n\n"
            end
        end
    end

    if report_string ~= "" then
        report_string = staff_name.."\n"..report_string.."\n\n"
        notification_table = notification_table..report_string
    end
end

local staves = finale.FCStaves()
staves:LoadAll()
for staff in each(staves) do
    local music_region = finenv.Region()
    music_region:SetCurrentSelection()
    if music_region:IsStaffIncluded(staff:GetItemNo()) then
        find_redundant(staff:GetItemNo())
    end
end

if notification_table == "" then
    finenv.UI():AlertInfo("No redundant dynamics found.", "Redundant Dynamics")
else
    finenv.UI():AlertInfo(notification_table, "Redundant Dynamics")
end