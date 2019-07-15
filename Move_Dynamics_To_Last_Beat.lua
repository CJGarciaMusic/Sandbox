function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.7"
    finaleplugin.Date = "7/11/2019"
    finaleplugin.CategoryTags = "Expression"
    return "Assign Dynamic to Last Beat", "Assign Dynamic to Last Beat", "Reassigns dynamics to the last beat of the measure"
end

local function move_dynamics(time_sig, beat_value, measure_num)
    local expressions = finale.FCExpressions()
    expressions:LoadAllForItem(measure_num)
    for e in each(expressions) do
        local ted = e:CreateTextExpressionDef()
        local cat_num = ted:GetCategoryID()
        local cat = finale.FCCategoryDef()
        cat:Load(cat_num)
        if string.find(cat:CreateName().LuaString, "Dynamics") then
            if e:GetMeasurePos() >= time_sig * beat_value then
                if (beat_value == 384) or (beat_value == 768) or (beat_value == 1536) or (beat_value == 3072) or (beat_value == 6144) or (beat_value == 12288)then
                    e:SetMeasurePos(((time_sig * 3) - 1) * (beat_value / 3))
                else
                    e:SetMeasurePos((time_sig - 1) * beat_value)
                end
                e:SetHorizontalPos(0)
                e:Save()
            end
        end
    end
end

local ms = finale.FCMeasures()
ms:LoadRegion(finenv.Region())
for m in each (ms) do
    local get_time = m:GetTimeSignature()
    if get_time:GetCompositeTop() then
        finenv.UI():AlertError("A composite time signaute was detected.\nMeasure: "..m.ItemNo.." will be skipped over", nil)
    else
        move_dynamics(get_time:CalcBeats(), get_time:GetBeatDuration(), m.ItemNo)
    end
end