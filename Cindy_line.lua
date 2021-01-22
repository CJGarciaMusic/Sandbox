function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "10/07/2020"
    return "Custom Line Width", "Custom Line Width", "Changes the custom line width to 154 evpus"
end

local sizeprefs = finale.FCSizePrefs()
sizeprefs:Load(1)
sizeprefs:SetStaffLineThickness(2.40625 * 64)
sizeprefs:SetThinBarlineThickness(3.84375 * 64)
sizeprefs:SetEnclosureThickness(2.40625 * 64)
sizeprefs:SetLedgerLineThickness(3.84375 * 64)
sizeprefs:SetStemLineThickness(2.40625 * 64)
sizeprefs:Save()

local customsmartlinedefs = finale.FCCustomSmartLineDefs()
customsmartlinedefs:LoadAll()
for csld in each(customsmartlinedefs) do
    if csld:GetLineStyle() == 0 then
        csld:SetLineWidth(154)
        csld:Save()
    end
end

local smartshapeprefs = finale.FCSmartShapePrefs()
smartshapeprefs:Load(1)
smartshapeprefs:SetLineWidth(154)
smartshapeprefs:Save()