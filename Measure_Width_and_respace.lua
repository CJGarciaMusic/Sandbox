function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "4/8/2020"
    finaleplugin.CategoryTags = "Note"
   return "Measure Width 0", "Measure Width 0", "Sets the default minimum width of a measure to 0 in the preferences, then selects all non-numerical staves, applies music spacing, then updates the layout."
end

local prefs = finale.FCMusicSpacingPrefs()
prefs:Load(1)
prefs:SetMinMeasureWidth(0)
prefs:Save()

local staff_list = {}

local staves = finale.FCStaves()
staves:LoadAll()
for staff in each(staves) do
    if staff:GetLineCount() > 0 then
        table.insert(staff_list, staff:GetItemNo())
    end
end

local ui = finenv.UI()

local music_region = finenv.Region()
music_region:SetFullDocument()
music_region:SetStartStaff(staff_list[1])
music_region:SetEndStaff(staff_list[#staff_list])
music_region:SetInDocument()

ui:MenuCommand(finale.MENUCMD_NOTESPACING)
finale.FCStaffSystems.UpdateFullLayout()