function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 CJ Garcia Music"
    finaleplugin.Version = "1.0"
    finaleplugin.Date = "9/15/2020"
    finaleplugin.CategoryTags = "Batch"
    return "Fit Staves To Page", "Fit Staves To Page", "Stretches the distances between systems to fit the page margins."
end

local staffsystems = finale.FCStaffSystems()
staffsystems:LoadAll()
local total_distance = {}
for ss in each(staffsystems) do
   local myNumberResult = ss:GetSpaceAbove()
   table.insert(total_distance, myNumberResult)
end
-- staffsystems:SaveAll()


finenv.UI():AlertInfo(total_distance[0], nil)
