function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 MakeMusic"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "7/15/2020"
    finaleplugin.CategoryTags = "Expression"
    return "Remove Redundant Dynamics", "Remove Redundant Dynamics", "Asks if you'd like to remove the redundant dynamics in a selected region."
end

function delete_dynamic(staff, measure_num, exp_id)
    local region = finenv.Region()
    region:SetStartStaff(staff)
    region:SetEndStaff(staff)
    region:SetStartMeasure(measure_num)
    region:SetEndMeasure(measure_num)
    local expressions = finale.FCExpressions()
    expressions:LoadAllForRegion(region)

    for exp in each(expressions) do
        local exp_def = exp:CreateTextExpressionDef()
        if exp_def:GetTextID() == exp_id then
            exp:DeleteData()
        end
    end
end


local ask_regions = {}

function find_redundant(staff_num)
    
    local music_region = finenv.Region()
    music_region:SetStartStaff(staff_num)
    music_region:SetEndStaff(staff_num)

    local expressions = finale.FCExpressions()
    expressions:LoadAllForRegion(finenv.Region())

    local comparison_table = {}
    local measure_info_table = {}
    for exp in each(expressions) do
        local exp_def = exp:CreateTextExpressionDef()
        if exp_def:GetCategoryID() == 1 then
            table.insert(comparison_table, exp_def:GetTextID())
            table.insert(measure_info_table, {exp:GetMeasure(), exp:GetMeasurePos(), exp:GetStaff()})
        end
    end


    for k, v in pairs(comparison_table) do
        if comparison_table[k + 1] ~= nil then
            if v == comparison_table[k + 1] then
                table.insert(ask_regions, {measure_info_table[k][1], measure_info_table[k][2], measure_info_table[k + 1][1], measure_info_table[k + 1][2], measure_info_table[k][3], comparison_table[k]})
            end
        end
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

if #ask_regions > 0 then
    for k, v in pairs(ask_regions) do
        local music_region = finenv.Region()
        music_region:SetStartStaff(ask_regions[k][5])
        music_region:SetEndStaff(ask_regions[k][5])
        music_region:SetStartMeasure(ask_regions[k][1])
        music_region:SetEndMeasure(ask_regions[k][3])
        finenv.UI():MoveToMeasure(ask_regions[k][1], ask_regions[k][5])
        music_region:SetInDocument()
        finenv.UI():RedrawDocument()
        finenv.UI():MenuPositionCommand(2, 9, -1)
        local the_ask = finenv.UI():AlertYesNoCancel("Would you like to delete the redundant dynamics?\n\nPress 'Yes' to remove the last dynamic\nPress 'Cancel' to remove the first dyanic\nPress 'No' to do nothing and continue onward.", "Redundant Dynamics")

        if the_ask == 1 then
            delete_dynamic(ask_regions[k][5], ask_regions[k][1], ask_regions[k][6])
        elseif the_ask == 2 then
            delete_dynamic(ask_regions[k][5], ask_regions[k][3], ask_regions[k][6])
        end
    end
else
    finenv.UI():AlertInfo("No redundant dynamics found", "Redundany Dynaics")
end