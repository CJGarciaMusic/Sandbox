function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.2"
    finaleplugin.Date = "5/22/2019"
    finaleplugin.CategoryTags = "Expression"
    return "Expression - Add mf", "Expression - Add mf", "Adds a mf to the selected notes in a region"
end

first_expression = {}

function addExpression(staff_num, measure_num, measure_pos)
    add_expression=finale.FCExpression()
    add_expression:SetStaff(staff_num)
    add_expression:SetVisible(true)
    add_expression:SetMeasurePos(measure_pos)
    add_expression:SetScaleWithEntry(false)
    add_expression:SetPartAssignment(true)
    add_expression:SetScoreAssignment(true)
    add_expression:SetID(first_expression[1])
    local and_cell = finale.FCCell(measure_num, staff_num)
    add_expression:SaveNewToCell(and_cell)
end

function getFirstNote()
    for staff_range = finenv.Region():GetStartStaff(), finenv.Region():GetEndStaff() do
        local first_note = {}
        local music_range = finenv.Region()
        music_range:SetStartStaff(staff_range)
        music_range:SetEndStaff(staff_range)
        local measures = finale.FCMeasures()
        measures:LoadRegion(music_range)
        
        for m in each(measures) do
            for noteentry in eachentrysaved(finenv.Region()) do
                if noteentry:IsNote() then
                    table.insert(first_note, {noteentry:GetStaff(), noteentry:GetMeasure(), noteentry:GetMeasurePos()})
                end
            end
        end
        addExpression(first_note[1][1], first_note[1][2], first_note[1][3])
    end
end

function CreateExpression(glyph, table_name)
    local ex_ted = finale.FCTextExpressionDef()
    local ex_textstr = finale.FCString()
    ex_textstr.LuaString = "^fontMus(Font0,0)^size(24)^nfx(0)"..glyph
    ex_ted:SaveNewTextBlock(ex_textstr)
    
    local and_descriptionstr = finale.FCString()
    and_descriptionstr.LuaString="mezzo forte (velocity = 75)"
    ex_ted:SetDescription(and_descriptionstr)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(1)
    ex_ted:AssignToCategory(cat_def)
    ex_ted:SetUseCategoryPos(true)
    ex_ted:SetUseCategoryFont(true)
    ex_ted:SaveNew()
    table.insert(table_name, ex_ted:GetItemNo())  
end

function findExpression(font, glyph, table_name)
    local matching_glyphs = {}
    local exp_defs = finale.FCTextExpressionDefs()
    local exp_def = finale.FCTextExpressionDef()
    exp_defs:LoadAll()
    local already_exists = 0
    for exp in each(exp_defs) do
        if (string.find(exp:CreateTextString().LuaString, font) ~=nil) and (string.find(exp:CreateTextString().LuaString, glyph) ~= nil) then
            already_exists = exp:GetItemNo()
            table.insert(matching_glyphs, already_exists)
        end
    end
    if matching_glyphs[1] == nil then
        CreateExpression(string.sub(glyph, 2), table_name)
    else
        exp_def:Load(matching_glyphs[1])
        table.insert(table_name, exp_def:GetItemNo())  
    end
end

findExpression("^^fontMus", ")F", first_expression)
getFirstNote()
