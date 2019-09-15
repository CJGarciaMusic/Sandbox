local measures = finale.FCMeasures()
measures:LoadAll()
for m in each(measures) do
    local expressions = m:CreateExpressions()
    for exp in each(expressions) do
        local ted = exp:CreateTextExpressionDef()
        if ted:GetCategoryID() == 2 then
            print(m.ItemNo)
            m:SetShowTimeSignature(finale.SHOWSTATE_SHOW)
            m:Save()
        end
    end
end