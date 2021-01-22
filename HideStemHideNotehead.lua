function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "5/25/2020"
    return "Hide Stem Hide Notehead", "Hide Stem Hide Notehead", "Changes the notehead to character 202 and the stem to character 95"
end

for entry in eachentrysaved(finenv.Region()) do
    for note in each(entry) do
        local noteheadmod = finale.FCNoteheadMod()
        noteheadmod:SetNoteEntry(entry)
        noteheadmod:SetCustomChar(202)
        noteheadmod:SaveAt(note)
    end
    local stem = finale.FCCustomStemMod()        
    stem:SetNoteEntry(entry)
    stem:UseUpStemData(entry:CalcStemUp())
    if stem:LoadFirst() then
        stem.ShapeID = 95    
        stem:Save()
    else
        stem.ShapeID = 95
        stem:SaveNew()
    end
end