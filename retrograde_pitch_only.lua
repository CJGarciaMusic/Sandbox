function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "5/5/2019"
    return "Retorgrade Pitch Only", "Retorgrade Pitch Only", "Retorgrades only the pitch, not the rhythms."
end

function retrograde_pitch_only()
    local pitch_list = {}
    for noteentry in eachentrysaved(finenv.Region()) do
        for note in each(noteentry) do
            table.insert(pitch_list, note:CalcMIDIKey())
        end
    end
    local count = 1
    local reverse_list = {}
    for i = #pitch_list, 1, -1 do
        reverse_list[count] = pitch_list[i]
        count = count + 1
    end
    count = 1
    for noteentry in eachentrysaved(finenv.Region()) do
        for note in each(noteentry) do
            note:SetMIDIKey(reverse_list[count])
        end
        count = count + 1
    end
end

function run()
    local can_run = true
    for noteentry in eachentrysaved(finenv.Region()) do
        if noteentry:GetCount() > 1 then
            can_run = false
        end
    end
    if can_run == true then
        retrograde_pitch_only()
    else
        finenv.UI():AlertInfo("There appears to be polyphony in your region. Please make sure your selection is monophonic and try again")
        return
    end
end

run()