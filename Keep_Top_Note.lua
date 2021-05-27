function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "©2021 MakeMusic"
    finaleplugin.Version = "1.0"
    finaleplugin.Date = "03/22/2021"
    return "Keep Top Note", "Keep Top Note", "Deletes all notes that are not the top note in a single layer."
end

function chord_line_keep_top() 
    for entry in eachentrysaved(finenv.Region()) do
        while (entry.Count >= 2) do
            local bottom_note = entry:CalcLowestNote(nil)
            entry:DeleteNote(bottom_note)
        end
    end
end

chord_line_keep_top()