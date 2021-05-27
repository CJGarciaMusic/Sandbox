function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "©2021 MakeMusic"
    finaleplugin.Version = "1.0"
    finaleplugin.Date = "03/22/2021"
    return "Delete Bottom Note", "Delete Bottom Note", "Removes the bottom note from a chord in a single layer."
end

function chord_line_delete_bottom()
    for entry in eachentrysaved(finenv.Region()) do
        if (entry.Count >= 2) then
            local bottom_note = entry:CalcLowestNote(nil)
            entry:DeleteNote(bottom_note)
        end
    end
end

chord_line_delete_bottom()