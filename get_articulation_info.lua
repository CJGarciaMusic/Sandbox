local ads = finale.FCArticulationDefs()
ads:LoadAll()
for ad in each(ads) do
    print(ad:GetMainSymbolChar())
    print(ad:GetMainSymbolFont())
    print(ad:GetAboveSymbolChar())
    print(ad:GetAboveUsesMain())
    print(ad:GetAlwaysPlaceOutsideStaff())
    print(ad:GetAttachToTopNote())
    print(ad:GetAttackIsPercent())
    print(ad:GetAutoPosSide())
    print(ad:GetAvoidStaffLines())
    print(ad:GetBelowSymbolChar())
    print(ad:GetBelowUsesMain())
    print(ad:GetBottomAttack())
    print(ad:GetBottomDuration())
    print(ad:GetBottomVelocity())
    print(ad:GetCenterHorizontally())
    print(ad:GetCopyMainSymbol())
    print(ad:GetCopyMainSymbolHorizontally())
    print(ad:GetDefaultVerticalPos())
    print(ad:GetDurationIsPercent())
    print(ad:GetMainHandleHorizontalOffset())
    print(ad:GetMainHandleVerticalOffset())
    print(ad:GetFlippedHandleHorizontalOffset())
    print(ad:GetFlippedHandleVerticalOffset())
    print(ad:GetFlippedSymbolChar())
    print(ad:GetFlippedSymbolFont())
    print(ad:GetInsideSlurs())
    print(ad:GetOnScreenOnly())
    print(ad:GetPlayback())
    print(ad:GetTopAttack())
    print(ad:GetTopDuration())
    print(ad:GetTopVelocity())
    print(ad:GetVelocityIsPercent())
    local fonti = ad:CreateMainSymbolFontInfo()
    print(fonti:GetAbsolute())
    print(fonti:GetBold())
    print(fonti:GetEnigmaStyles())
    print(fonti:GetHidden())
    print(fonti:GetItalic())
    print(fonti:GetName())
    print(fonti:GetSize())
    print(fonti:GetSizeFloat())
    print(fonti:GetStrikeOut())
    print(fonti:GetUnderline())
    local fontif = ad:CreateFlippedSymbolFontInfo()
    print(fontif:GetAbsolute())
    print(fontif:GetBold())
    print(fontif:GetEnigmaStyles())
    print(fontif:GetHidden())
    print(fontif:GetItalic())
    print(fontif:GetName())
    print(fontif:GetSize())
    print(fontif:GetSizeFloat())
    print(fontif:GetStrikeOut())
    print(fontif:GetUnderline())
    print("========")
end