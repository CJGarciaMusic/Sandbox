function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 MakeMusic"
    finaleplugin.Version = "1.3"
    finaleplugin.Date = "6/2/2020"
    finaleplugin.CategoryTags = "Page"
    return "Move FJH Text Block", "Move FJH Text Block", "Moves the copyright and publisher number text block so there's no collision with the music"
end

function page_text_update()
    local new_text = ""
    local old_block_to_delete = {}
    local page_text = finale.FCPageTexts()
    page_text:LoadAll()
    for pt in each(page_text) do
        if (string.find(pt:CreateTextString().LuaString, "WARNING!") ~= nil) or (string.find(pt:CreateTextString().LuaString, "B%d%d%d%d") ~= nil) or (string.find(pt:CreateTextString().LuaString, "ST%d%d%d%d") ~= nil) then 
            pt:SetVerticalPos(-222)
            pt:Save()
        end
    end
end

page_text_update()