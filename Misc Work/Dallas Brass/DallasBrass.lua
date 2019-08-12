function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "8/12/2019"
    return "Dallas Brass", "Dallas Brass", "Flips Dallas Brass items"
end

local artic_defs = finale.FCArticulationDefs()
artic_defs:LoadAll()
for art in each(artic_defs) do
    if (art:GetAboveSymbolChar() == 62) and ((art:GetFlippedSymbolChar() == 62))then
        art:SetTopVelocity(115)
        art:SetBottomVelocity(115)
        art:Save()
    end
    if (art:GetMainSymbolChar() == 94) and (art:GetFlippedSymbolChar() == 118) then
        art:SetVelocityIsPercent(true)
        art:SetTopVelocity(115)
        art:SetBottomVelocity(115)
        art:SetDurationIsPercent(true)
        art:SetTopDuration(60)
        art:SetBottomDuration(60)
        art:Save()
    end
end