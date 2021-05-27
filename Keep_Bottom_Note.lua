function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "©2021 MakeMusic"
    finaleplugin.Version = "1.0"
    finaleplugin.Date = "03/22/2021"
    return "Keep Bottom Note", "Keep Bottom Note", "Deletes all notes that are not the bottom note in a single layer."
end

function chord_line_keep_bottom() 
    for entry in eachentrysaved(finenv.Region()) do
        while (entry.Count >= 2) do
            local top_note = entry:CalcHighestNote(nil)
            entry:DeleteNote(top_note)
        end
    end
end

chord_line_keep_bottom()