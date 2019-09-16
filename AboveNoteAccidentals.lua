function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.2"
    finaleplugin.Date = "8/12/2019"
    return "Accidentals Above Notes", "Accidentals Above Notes", "Moves accidentals above or below notes in a selected region."
end

for noteentry in eachentrysaved(finenv.Region()) do
    for note in each(noteentry) do
        if note.Accidental == true then
            local am = finale.FCAccidentalMod()
                am:SetNoteEntry(noteentry)
                am:SetUseCustomVerticalPos(true)
            if (noteentry.LayerNumber == 1) and (noteentry:CalcStemUp()) then
                local distanceprefs = finale.FCDistancePrefs()
                distanceprefs:Load(1)
                local minus_pref = 0 + distanceprefs:GetAccidentalNoteSpace()
                local note_width = note:CalcNoteheadWidth()
                local total_dist = minus_pref + note_width
                local up_stem = noteentry:CalcStemLength()
                
                local extra_value = 0
                if (note:GetRaiseLower() < 0) then
                    extra_value = 24
                elseif (note:GetRaiseLower() == 0) then
                    extra_value = 45
                elseif (note:GetRaiseLower() == 1) then
                    extra_value = 45
                elseif (note:GetRaiseLower() == 2) then
                    extra_value = 24
                end
                am:SetVerticalPos(up_stem + extra_value)
                am:SetHorizontalPos(total_dist)
                am:SaveAt(note)
            end
            if (noteentry.LayerNumber == 1) and (noteentry:CalcStemUp() == false) then
                local distanceprefs = finale.FCDistancePrefs()
                distanceprefs:Load(1)
                local minus_pref = 0 + distanceprefs:GetAccidentalNoteSpace()
                local note_width = note:CalcNoteheadWidth()
                local total_dist = minus_pref + note_width
                local down_stem = 0 - (note:CalcStaffPosition() * 12)
                local am = finale.FCAccidentalMod()
                am:SetNoteEntry(noteentry)
                am:SetUseCustomVerticalPos(true)
                local extra_value = 38
                if (note:GetRaiseLower() < 0) then
                    extra_value = 24
                elseif (note:GetRaiseLower() == 0) then
                    extra_value = 45
                elseif (note:GetRaiseLower() == 1) then
                    extra_value = 45
                elseif (note:GetRaiseLower() == 2) then
                    extra_value = 24
                end
                am:SetVerticalPos(down_stem + extra_value)
                am:SetHorizontalPos(total_dist)
                am:SaveAt(note)
            end
        end
    end
end