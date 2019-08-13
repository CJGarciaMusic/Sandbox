function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "8/8/2019"
    return "SFard Notation", "SFard Notation", "Converts the selected tab region to SFard block notation"
end

local newfont = "SFard"
local noteheadmod = finale.FCNoteheadMod()
noteheadmod:SetUseCustomFont(true)
noteheadmod.FontName = newfont

for noteentry in eachentrysaved(finenv.Region()) do
    for note in each(noteentry) do
    if noteentry.Duration == 512 then
        if note:CalcMIDIKey() == 64 then
            noteheadmod.CustomChar = 70
            noteheadmod:SaveAt(note)
        end
        if (note:CalcMIDIKey() == 65) or (note:CalcMIDIKey() == 67) then
            noteheadmod.CustomChar = 99
            noteheadmod:SaveAt(note)
        end
    end
    if noteentry.Duration == 1024 then
        if note:CalcMIDIKey() == 64 then
            noteheadmod.CustomChar = 69
            noteheadmod:SaveAt(note)
        end
        if (note:CalcMIDIKey() == 65) or (note:CalcMIDIKey() == 67) then
            noteheadmod.CustomChar = 98
            noteheadmod:SaveAt(note)
        end
    end

if noteentry.Duration == 2048 then
        if note:CalcMIDIKey() == 64 then
            noteheadmod.CustomChar = 67
            noteheadmod:SaveAt(note)
        end
        if (note:CalcMIDIKey() == 65) or (note:CalcMIDIKey() == 67) then
            noteheadmod.CustomChar = 96
            noteheadmod:SaveAt(note)
        end
    end
if noteentry.Duration == 4096 then
        if note:CalcMIDIKey() == 64 then
            noteheadmod.CustomChar = 65
            noteheadmod:SaveAt(note)
        end
        if (note:CalcMIDIKey() == 65) or (note:CalcMIDIKey() == 67) then
            noteheadmod.CustomChar = 94
            noteheadmod:SaveAt(note)
        end
    end
    end
end

local ui = finenv.UI()
ui:MenuCommand(finale.MENUCMD_NOTESPACING)

local measures = finale.FCMeasures()
measures:LoadAll()
for m in each(measures) do
   m.Width = 300
end

for noteentry in eachentrysaved(finenv.Region()) do
    local staff_color = finale.FCStaff()
    staff_color:Load(noteentry.Staff)
    staff_color:SetShowNoteColors(true)
    staff_color:Save()
  end