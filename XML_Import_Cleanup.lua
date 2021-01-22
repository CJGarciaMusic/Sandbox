function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 MakeMusic"
    finaleplugin.Version = "1.3"
    finaleplugin.Date = "6/2/2020"
    finaleplugin.CategoryTags = "Page"
    return "Sibelius XML Import Cleanup", "Sibelius XML Import Cleanup", "Just a couple of cleanup tasks after importing an XML created by Sibelius"
end
function update_staff_text()
    local staves = finale.FCStaves()
    staves:LoadAll()
    for staff in each(staves) do
        local new_text = finale.FCString()
        local old_string = staff:CreateFullNameString().LuaString
        local stringobject = finale.FCString()
        stringobject.LuaString = old_string
        local ss = finale.FCStaffSystem()
        local top_distance = 0
        if ss:Load(1) then
            top_distance = ss:GetTopMargin()
        end
        local pagetext = finale.FCPageText()
        pagetext.HorizontalAlignment = finale.TEXTHORIZALIGN_LEFT
        pagetext.VerticalAlignment = finale.TEXTVERTALIGN_TOP
        pagetext.HorizontalPos = 0
        pagetext.VerticalPos = 0 - (top_distance + 16)
        pagetext.Visible = true
        pagetext.FirstPage = 1
        pagetext.LastPage = 1
        pagetext:SaveNewTextBlock(stringobject)
        pagetext:SaveNew(1)
        staff:SaveNewFullNameString(staff:CreateAbbreviatedNameString())
        staff:SetShowScoreStaffNames(false)
        staff:Save()  
    end
end
function rebeam_music()
    local region = finenv.Region()
    region:SetFullDocument()
    region:SetInDocument()
    finenv.UI():MenuCommand(finale.MENUCMD_REBEAM)
    finale.FCStaffSystems.UpdateFullLayout()
    finenv.UI():MenuPositionCommand(2, 9, -1)
    finenv.UI():MenuCommand(finale.MENUCMD_REDRAWSCREEN)
    finenv.UI():MenuCommand(finale.MENUCMD_NOTESPACING)
end
function page_text_update(pos_req, len_req, alignment_params, delete_bool)
    local new_text = ""
    local old_block_to_delete = {}
    local new_text_blocks_to_update = {}
    local page_text = finale.FCPageTexts()
    page_text:LoadAll()
    for pt in each(page_text) do
        if (pt:GetFirstPage()) > 1 then
            table.insert(old_block_to_delete, {pt:GetItemCmper(), pt:GetItemInci()})
        end
        local old_text = pt:CreateTextString() 
        old_text:TrimEnigmaTags()
        if len_req == "title" then
            if (pt:GetHorizontalAlignment() == pos_req) and ((string.find(pt:CreateTextString().LuaString, "nfx%(1%)") ~= nil) or (string.find(pt:CreateTextString().LuaString, "nfx%(65%)") ~= nil) or (string.find(pt:CreateTextString().LuaString, "nfx%(66%)") ~= nil)) then
                print(pt:GetHorizontalAlignment(), pt:CreateTextString().LuaString)
                new_text = new_text..pt:CreateTextString().LuaString.."\r"
                table.insert(old_block_to_delete, {pt:GetItemCmper(), pt:GetItemInci()})
            end
        else
            if (pt:GetHorizontalAlignment() == pos_req) and (string.len(old_text.LuaString) > len_req) then
                new_text = new_text..pt:CreateTextString().LuaString.."\r"
                table.insert(old_block_to_delete, {pt:GetItemCmper(), pt:GetItemInci()})
            end
        end
    end
    if delete_bool == true then
        for i = #old_block_to_delete, 1, -1 do
            local pt = finale.FCPageText()
            local value = old_block_to_delete[i]
            if pt:Load(value[1], value[2]) then
                pt:DeleteData()
            end
        end
        local stringobject = finale.FCString()
        stringobject.LuaString = new_text
        local pagetext = finale.FCPageText()
        pagetext.HorizontalAlignment = alignment_params[1]
        pagetext.VerticalAlignment = alignment_params[2]
        pagetext.HorizontalPos = alignment_params[3]
        pagetext.VerticalPos = alignment_params[4]
        pagetext.Visible = true
        pagetext.FirstPage = 1
        pagetext.LastPage = 1
        pagetext:SaveNewTextBlock(stringobject)
        pagetext:SaveNew(1)
        table.insert(new_text_blocks_to_update, {pagetext:GetItemCmper(), pagetext:GetItemInci()})
    else
        for pt in each(page_text) do
            local old_text = pt:CreateTextString() 
            old_text:TrimEnigmaTags()
            if len_req == "title" then
                if (pt:GetHorizontalAlignment() == pos_req) and ((string.find(pt:CreateTextString().LuaString, "nfx%(1%)") ~= nil) or (string.find(pt:CreateTextString().LuaString, "nfx%(65%)") ~= nil) or (string.find(pt:CreateTextString().LuaString, "nfx%(66%)") ~= nil)) then
                    pt.HorizontalAlignment = alignment_params[1]
                    pt.VerticalAlignment = alignment_params[2]
                    pt.HorizontalPos = alignment_params[3]
                    pt.VerticalPos = alignment_params[4]
                    pt.Visible = true
                    pt.FirstPage = 1
                    pt.LastPage = 1
                    pt:Save()
                    table.insert(new_text_blocks_to_update, {pt:GetItemCmper(), pt:GetItemInci()})
                end
            else
                if (pt:GetHorizontalAlignment() == pos_req) and (string.len(old_text.LuaString) > len_req) then
                    pt.HorizontalAlignment = alignment_params[1]
                    pt.VerticalAlignment = alignment_params[2]
                    pt.HorizontalPos = alignment_params[3]
                    pt.VerticalPos = alignment_params[4]
                    pt.Visible = true
                    pt.FirstPage = 1
                    pt.LastPage = 1
                    pt:Save()
                    table.insert(new_text_blocks_to_update, {pt:GetItemCmper(), pt:GetItemInci()})
                end
            end
        end
    end
    for key, value in pairs(new_text_blocks_to_update) do
        local pagetxt = finale.FCPageText()
        if pagetxt:Load(value[1], value[2]) then
            local text_blocks = pagetxt:CreateTextBlock()
            text_blocks:SetJustification(alignment_params[5])
            text_blocks:Save()
        end
    end
end
page_text_update(2, "title", {finale.TEXTHORIZALIGN_CENTER, finale.TEXTVERTALIGN_TOP, 0, 0, finale.TEXTJUSTIFY_CENTER}, true)
page_text_update(0, 1, {finale.TEXTHORIZALIGN_LEFT, finale.TEXTVERTALIGN_TOP, 0, -144, finale.TEXTJUSTIFY_LEFT}, true)
page_text_update(1, 1, {finale.TEXTHORIZALIGN_RIGHT, finale.TEXTVERTALIGN_TOP, 0, -144, finale.TEXTJUSTIFY_RIGHT}, false)
page_text_update(2, 100, {finale.TEXTHORIZALIGN_CENTER, finale.TEXTVERTALIGN_BOTTOM, 0, 0, finale.TEXTJUSTIFY_CENTER}, true)
update_staff_text()
rebeam_music()