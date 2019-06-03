function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.2"
    finaleplugin.Date = "5/31/2019"
    finaleplugin.CategoryTags = "Articulation"
    return "Breath Mark Expression", "Breath Mark Expression", "Replaces the breath mark articulation with a breath mark expression. Creates a Breath Mark Expression if one is not already in the doucment, uses the last breath mark in the expressions dialogue if there already is one."
end

local breath_mark_id = {}

local function swap_artic_for_exp()
    local music_region = finenv.Region()
    music_region:SetFullDocument()
    for noteentry in eachentrysaved(music_region) do 
        local artics = noteentry:CreateArticulations()
        for a in each(artics) do
            local def = a:CreateArticulationDef()
            if def:GetAboveSymbolChar() == 44 then
                a:DeleteData()
                local and_expression=finale.FCExpression()
                and_expression:SetStaff(noteentry.Staff)
                and_expression:SetVisible(true)
                and_expression:SetMeasurePos(noteentry.MeasurePos)
                and_expression:SetScaleWithEntry(true)
                and_expression:SetLayerAssignment(noteentry.LayerNumber)
                and_expression:SetPartAssignment(true)
                and_expression:SetScoreAssignment(true)
                and_expression:SetPlaybackLayerAssignment(1)
                and_expression:SetID(breath_mark_id[1])
                local and_cell = finale.FCCell(noteentry.Measure, noteentry.Staff)
                and_expression:SaveNewToCell(and_cell)
            end
        end
    end
end

local function createBreathMark()
    local exp_def = finale.FCTextExpressionDef()
    local textstr = finale.FCString()
    textstr.LuaString = "^fontMus(Font0,0)^size(24)^nfx(0),"
    exp_def:SaveNewTextBlock(textstr)
    local descriptionstr = finale.FCString()
    descriptionstr.LuaString="Breath Mark"
    exp_def:SetDescription(descriptionstr)
    local cat_def = finale.FCCategoryDef()
    cat_def:Load(7)
    exp_def:AssignToCategory(cat_def)
    exp_def:SetUseCategoryPos(false)
    exp_def:SetVerticalAlignmentPoint(finale.ALIGNVERT_STAFF_REFERENCE_LINE)
    exp_def:SetVerticalBaselineOffset(36)
    exp_def:SetHorizontalJustification(finale.EXPRJUSTIFY_LEFT)
    exp_def:SetHorizontalAlignmentPoint(finale.ALIGNHORIZ_RIGHTALLNOTEHEADS)
    exp_def:SetHorizontalOffset(48)
    exp_def:SetBreakMMRest(false)
    exp_def:SaveNew()
    breath_mark_id[1] = exp_def:GetItemNo()
    swap_artic_for_exp()
end

local function getBreathID()
    local exp_defs = finale.FCTextExpressionDefs()
    exp_defs:LoadAll()
    for ted in each(exp_defs) do
        if string.find(ted:CreateTextString().LuaString, "^fontMus(Font0,0)^size(24)^nfx(0),") then
               table.insert(breath_mark_id, ted:GetItemNo())
        end
    end
    if breath_mark_id[1] == nil then
        createBreathMark()
    else
        swap_artic_for_exp()
    end
end

getBreathID()