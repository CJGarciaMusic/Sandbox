function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "©2021 MakeMusic"
    finaleplugin.Version = "1.0"
    finaleplugin.Date = "03/22/2021"
    return "Delete Top Note", "Delete Top Note", "Removes the top note from a chord in a single layer."
end

function chord_line_delete_top() 
    for entry in eachentrysaved(finenv.Region()) do
        if (entry.Count >= 2) then
            local top_note = entry:CalcHighestNote(nil)
            entry:DeleteNote(top_note)
        end
    end
end

chord_line_delete_top()