function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 MakeMusic"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "7/6/2020"
    finaleplugin.CategoryTags = "Expression"
    return "Move Rehearsal Expressions", "Move Rehearsal Expressions", "Moves anything in the Rehearsal Marker category to the Tempo Marking Category that isn't already defined as an autorehearsal marker."
end

local teds = finale.FCTextExpressionDefs()
teds:LoadAll()
for ted in each(teds) do
    if ted:GetCategoryID() == 6 then
        if ted:IsAutoRehearsalMark() == false then
            ted:SetCategoryID(2)
            ted:Save()
        end
    end
end