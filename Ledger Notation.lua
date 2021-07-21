function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2021 CJ Garcia Music"
    finaleplugin.Version = "1.0"
    finaleplugin.Date = "7/21/2021"
    finaleplugin.CategoryTags = "Note"
    return "RR Ledger Notation", "RR Ledger Notation", "Converts standard notation into Rebecca Rose Ledger Notation"
end

local nm = finale.FCNoteheadMod()
local font_info = finale.FCFontInfo()
font_info:SetSize(12)
font_info:SetAbsolute(true)
font_info:SetBold(true)
font_info:SetName("Arial")

function change_octave(pitch_string, n)
    pitch_string.LuaString = pitch_string.LuaString:sub(1, -2)..(tonumber(string.sub(pitch_string.LuaString, -1)) + n)
    return pitch_string
end

function add_unison_pitch(pitch_string)
    local letters = "ABCDEFGABCDEFG"
    local note_name_pos = letters:find(pitch_string.LuaString:sub(1,1))
    local new_note = letters:sub(note_name_pos + 0, note_name_pos + 0)
    pitch_string.LuaString = new_note .. pitch_string.LuaString:sub(2)

    if (note_name_pos >= 8) or (note_name_pos <= 2) then
        pitch_string = change_octave(pitch_string, 1)
    end
    return pitch_string
end

function add_accidetnal(entry, acc_char) 
    local nm = finale.FCNoteheadMod()
    local font_info = finale.FCFontInfo()
    font_info:SetSize(12)
    font_info:SetAbsolute(true)
    font_info:SetBold(true)
    font_info:SetName("Arial")
    -- for entry in eachentrysaved(finenv.Region()) do
        if (entry.Count == 1) then 
            local note = entry:CalcLowestNote(nil)
            local pitch_string = finale.FCString()
            local measure = entry:GetMeasure()
            measure_object = finale.FCMeasure()
            measure_object:Load(measure)
            local key_sig = measure_object:GetKeySignature()
            note:GetString(pitch_string, key_sig, false, true)
            pitch_string = add_unison_pitch(pitch_string)
            local new_note = entry:AddNewNote()
            new_note:SetString(pitch_string, key_sig, true)
            nm:SetNoteEntry(entry)
            nm:SetUseCustomFont(true)
            nm:SetFontInfo(font_info)
            entry:SetLedgerLines(false)
            nm:SetUseDefaultVerticalPos(false)
            nm:SetVerticalPos(0)
            if entry.Duration >= 4048 then
                nm:SetHorizontalPos(6)
            else
                nm:SetHorizontalPos(4)
            end
            nm.CustomChar = acc_char
            nm:SaveAt(new_note)
        end
    -- end
end

function first_run()

    for noteentry in eachentrysaved(finenv.Region()) do 
        nm:SetNoteEntry(noteentry)
        nm:SetUseCustomFont(true)
        nm:SetFontInfo(font_info)
        noteentry:SetLedgerLines(false)
        noteentry:SetAccidentals(false)
        for note in each(noteentry) do
            note:SetAccidental(false)
            note:SetAccidentalFreeze(true)
            nm:SetUseDefaultVerticalPos(false)
            nm:SetVerticalPos(0)
            if note:CalcPitchChar() == "A" then
                nm.CustomChar = 65
            end
            if note:CalcPitchChar() == "B" then
                nm.CustomChar = 66
            end
            if note:CalcPitchChar() == "C" then
                nm.CustomChar = 67
            end
            if note:CalcPitchChar() == "D" then
                nm.CustomChar = 68
            end
            if note:CalcPitchChar() == "E" then
                nm.CustomChar = 69
            end
            if note:CalcPitchChar() == "F" then
                nm.CustomChar = 70
            end
            if note:CalcPitchChar() == "G" then
                nm.CustomChar = 71
            end
            nm:SaveAt(note)
        end
    end

    for noteentry in eachentrysaved(finenv.Region()) do 
        for note in each(noteentry) do
            if note:CalcPitchRaiseLower(note:GetAccidental()) == 1 then
                add_accidetnal(noteentry, 35)
            end
            if note:CalcPitchRaiseLower(note:GetAccidental()) == -1 then
                add_accidetnal(noteentry, 98)
            end
        end
    end
end

first_run()

local staffsystems = finale.FCStaffSystems()
staffsystems:LoadAll()
for ss in each(staffsystems) do
    local measure = finale.FCMeasure()
    measure:Load(ss:GetFirstMeasure())
    measure:SetWidth(0)
    measure:Save()
end