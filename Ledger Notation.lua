local nm = finale.FCNoteheadMod()
local font_info = finale.FCFontInfo()
font_info:SetSize(12)
font_info:SetAbsolute(true)
font_info:SetBold(true)
font_info:SetName("Arial")
for noteentry in eachentrysaved(finenv.Region()) do 
    nm:SetNoteEntry(noteentry)
    nm:SetUseCustomFont(true)
    nm:SetFontInfo(font_info)

    for note in each(noteentry) do
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