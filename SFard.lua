function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.9"
    finaleplugin.Date = "12/01/2019"
    return "SFard Notation", "SFard Notation", "Converts the document from tab to SFard block notation"
end

local string_num = {}
local noteentry_list = {}
local guitar_string_midi_notes = {11.8, 9.8, 8, 6, 4, 2}
local bass_string_midi_notes = {7.6, 5.6, 3.6, 1.6}

function set_page_size()
    local distanceprefs = finale.FCDistancePrefs()
    distanceprefs:Load(1)
    distanceprefs:SetSpaceAfter(0)
    distanceprefs:SetSpaceBefore(0)
    distanceprefs:Save()
    local musicspacingprefs = finale.FCMusicSpacingPrefs()
    musicspacingprefs:Load(1)
    musicspacingprefs:SetMinimumItemDistance(0)
    musicspacingprefs:Save()
    local pages = finale.FCPages()
    pages:LoadAll()
    for p in each(pages) do
        p:SetTopMargin(144)
        p:SetBottomMargin(144)
        p:SetLeftMargin(288)
        p:SetRightMargin(288)
        p:SetPercent(100)
        p:Save()
    end
    local staff_sys = finale.FCStaffSystems()
    staff_sys:LoadAll()
    for sys in each(staff_sys) do
        if sys:GetItemNo() == 1 then
            sys:SetTopMargin(362)
            sys:SetBottomMargin(200)
            sys:SetLeftMargin(0)
            sys:SetRightMargin(0)
            sys:SetResize(100)
            sys:SetSpaceAbove(0)
            sys:SetSpaceAfterMusic(0)
            sys:SetSpaceBeforeMusic(0)
            sys:SetStaffHeight(198 * 64)
            sys:Save()
        elseif sys:GetItemNo() ~= 1 then
            sys:SetTopMargin(144)
            sys:SetBottomMargin(200)
            sys:SetLeftMargin(0)
            sys:SetRightMargin(0)
            sys:SetResize(100)
            sys:SetSpaceAbove(0)
            sys:SetSpaceAfterMusic(0)
            sys:SetSpaceBeforeMusic(0)
            sys:SetStaffHeight(198 * 64)
            sys:Save()
        end
    end
end

function set_shapes(sfard_staff)
    local newfont = "SFard"
    local noteheadmod = finale.FCNoteheadMod()
    noteheadmod:SetUseCustomFont(true)
    noteheadmod.FontName = newfont

    for noteentry in eachentrysaved(sfard_staff) do
        for note in each(noteentry) do
            if noteentry.Duration == 256 then
                if note:CalcMIDIKey() == 0 then
                    noteheadmod.CustomChar = 71
                    noteheadmod:SaveAt(note)
                end
                for i = 1, 11 do
                    if (note:CalcMIDIKey() == i) then
                        noteheadmod.CustomChar = 100
                        noteheadmod:SaveAt(note)
                    end
                end
            end
            if noteentry.Duration == 512 then
                if note:CalcMIDIKey() == 0 then
                    noteheadmod.CustomChar = 70
                    noteheadmod:SaveAt(note)
                end
                for i = 1, 11 do
                    if (note:CalcMIDIKey() == i) then
                        noteheadmod.CustomChar = 99
                        noteheadmod:SaveAt(note)
                    end
                end
            end
            if noteentry.Duration == 1024 then
                if note:CalcMIDIKey() == 0 then
                    noteheadmod.CustomChar = 69
                    noteheadmod:SaveAt(note)
                end
                for i = 1, 11 do
                    if (note:CalcMIDIKey() == i) then
                        noteheadmod.CustomChar = 98
                        noteheadmod:SaveAt(note)
                    end
                end
            end
            if noteentry.Duration == 2048 then
                if note:CalcMIDIKey() == 0 then
                    noteheadmod.CustomChar = 67
                    noteheadmod:SaveAt(note)
                end
                for i = 1, 11 do
                    if (note:CalcMIDIKey() == i) then
                        noteheadmod.CustomChar = 96
                        noteheadmod:SaveAt(note)
                    end
                end
            end
            if noteentry.Duration == 4096 then
                if note:CalcMIDIKey() == 0 then
                    noteheadmod.CustomChar = 65
                    noteheadmod:SaveAt(note)
                end
                for i = 1, 11 do
                    if (note:CalcMIDIKey() == i) then
                        noteheadmod.CustomChar = 94
                        noteheadmod:SaveAt(note)
                    end
                end
            end
        end
    end
    local staff = finale.FCStaff()
    local music_region = finenv.Region()
    music_region:SetFullDocument()
    staff:Load(music_region:GetStartStaff())
    staff:SetHideMode(finale.STAFFHIDE_SCORE)
    staff:Save()
    set_page_size()
    music_region:SetFullDocument()
    local ui = finenv.UI()
    ui:MenuCommand(finale.MENUCMD_NOTESPACING)

    local measures = finale.FCMeasures()
    measures:LoadAll()
    for m in each(measures) do
        m:SetWidth(300)
        m:Save()
    end
end

function transpose_music(sfard_staff, num_of_strings)
    local count = 1
    for noteentry in eachentrysaved(sfard_staff) do
        local tnm = finale.FCTablatureNoteMod()
        tnm:SetNoteEntry(noteentry)
        for note in each(noteentry) do
            tnm:LoadAt(note)
            local var_num = guitar_string_midi_notes
            if num_of_strings == 6 then
                var_num = guitar_string_midi_notes
            elseif num_of_strings == 4 then
                var_num = bass_string_midi_notes
            end
            local new_midi = note:CalcMIDIKey() - ((string_num[count] + var_num[string_num[count]]) * 5)
            if new_midi > 11 then
                new_midi = new_midi - 12
            end
            note:SetMIDIKey(new_midi)
            tnm:SetStringNumber(string_num[count])
            tnm:SaveAt(note)                
            count = count + 1
        end
    end
    for noteentry in eachentrysaved(sfard_staff) do
        local tnm = finale.FCTablatureNoteMod()
        tnm:SetNoteEntry(noteentry)
        for note in each(noteentry) do
            tnm:LoadAt(note)
            if note:CalcMIDIKey() ~= 0 then
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(tnm:GetStringNumber())
                tnm:SaveAt(note_boarder)
            end
        end
    end
end

function copy_music(bottom_staff, num_of_strings)
    local region = finenv.Region()
    region:SetFullDocument()
    local topstaff = region.StartStaff
    local bottomstaff = bottom_staff
    if topstaff < 0 then
        return
    end
    if bottomstaff < 1 then
        return
    end
    if topstaff == bottomstaff then
        return
    end

    local topregion = finale.FCMusicRegion()
    topregion:SetRegion(region)
    topregion.EndStaff = topstaff

    local bottomregion = finale.FCMusicRegion()
    bottomregion:SetRegion(region)
    bottomregion.StartStaff = bottom_staff

    topregion:CopyMusic()
     
    for noteentry in eachentry(topregion) do
        table.insert(noteentry_list, noteentry)
        local tnm = finale.FCTablatureNoteMod()
        tnm:SetNoteEntry(noteentry)
        if tnm:LoadFirst() then
            for note in each(noteentry) do
                tnm:LoadAt(note)
                table.insert(string_num, tnm:GetStringNumber())
            end
        end
    end
     
    topregion.StartStaff = bottom_staff
    topregion.EndStaff = bottom_staff
    topregion:PasteMusic()

    topregion:ReleaseMusic()
     
    region:SetInDocument()

    transpose_music(bottomregion, num_of_strings)
    set_shapes(bottomregion)
end

function create_shape_staff(tab_staff, num_of_strings)
    local staffID = finale.FCStaves.Append()
    local staff = finale.FCStaff()
    local shape_staff = 0
    local efix32 = 64
    if staffID then
        staff:Load(staffID)
        staff:IsTablature(true)
        staff:SetNotationStyle(finale.STAFFNOTATION_TABLATURE)
        if num_of_strings == 6 then
            staff.InstrumentUUID = "1e1303c5-779b-4b96-ae9a-a15319434056"
        elseif num_of_strings == 4 then
            staff.InstrumentUUID = "c8bbb804-c633-467a-9b5c-4a3fed76f90e"
        end
        staff:SetFretInstrumentDefID(tab_staff)
        staff:SetBreakTablatureLines(false)
        staff:SetFretLetters(false)
        staff:SetLowestFret(0)
        staff:SetVerticalFretOffset(-12 * efix32)
        staff:SetShowFretboards(false)
        staff:SetLineCount(num_of_strings)
        staff:SetLineSpacing(36 * efix32)
        staff:SetShowMeasureNumbers(false)
        staff:SetShowKeySignatures(false)
        staff:SetShowTimeSignatures(false)
        staff:SetShowScoreStaffNames(false)
        staff:SetShowClefs(false)
        staff:SetShowStems(false)
        staff:SetShowNoteColors(true)
        staff:SetDisplayEmptyRests(false)
        staff:SetShowPartTimeSignatures(false)
        staff:SetShowPartStaffNames(false)
        staff:SetShowRests(false)
        string = finale.FCString()
        string.LuaString = tostring(num_of_strings).."-String Shape Tab"
        staff:SaveNewFullNameString(string)
        staff:Save()
        shape_staff = staff:GetItemNo()
    end
    staff:Load(shape_staff)
    local playbackdata = staff:CreateInstrumentPlaybackData()
    for layer = 1, 4 do
        local layerdef = playbackdata:GetNoteLayerData(layer)
        layerdef.Play = false
    end
    playbackdata:Save()
    staff:Load(0)
    staff:SetHideMode(finale.STAFFHIDE_CUTAWAY)
    copy_music(shape_staff, num_of_strings)
end

function create_SFard_instrument(inst_type)
    local ui = finenv.UI()
    ui:MenuCommand(finale.MENUCMD_VIEWPAGEVIEW)
    ui:MenuCommand(finale.MENUCMD_EDITSCORE)

    local tab_staves = finale.FCFretInstrumentDefs()
    tab_staves:LoadAll()
    local sf_itemno = 0
    for ts in each(tab_staves) do
        if inst_type == 4 then
            if ts:GetStringCount() == 4 then
                if ts:GetStringTuning(1) == 0 then
                    if ts:GetStringTuning(2) == 0 then
                        if ts:GetStringTuning(3) == 0 then
                            if (ts:GetStringTuning(4) == 0) then
                                sf_itemno = ts:GetItemNo()
                            end
                        end
                    end
                end
            end
        elseif inst_type == 6 then
            if ts:GetStringCount() == 6 then
                if ts:GetStringTuning(1) == 0 then
                    if ts:GetStringTuning(2) == 0 then
                        if ts:GetStringTuning(3) == 0 then
                            if (ts:GetStringTuning(4) == 0) then
                                if ts:GetStringTuning(5) == 0 then
                                    if ts:GetStringTuning(6) == 0 then
                                        sf_itemno = ts:GetItemNo()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if sf_itemno == 0 then
        local tab_staves = finale.FCFretInstrumentDefs()
        tab_staves:LoadAll()
        local tab_to_load = 0
        for ts in each(tab_staves) do
            if ts:GetStringCount() == inst_type then
                tab_to_load = ts:GetItemNo()
            end
        end
        local tab_staff = finale.FCFretInstrumentDef()
        tab_staff:Load(tab_to_load)
        local string = finale.FCString()
        string.LuaString = "SFard ("..tostring(inst_type).."-String)"
        tab_staff:SetName(string)
        for i = 1, inst_type do
            tab_staff:SetStringTuning(i, 0)
        end
        tab_staff:SaveNew()
        create_shape_staff(tab_staff:GetItemNo(), inst_type)
    else
        local staves = finale.FCStaves()
        staves:LoadAll()
        local sf_staff = 0
        for s in each(staves) do
            local music_region = finenv.Region()
            music_region:SetFullDocument()
            music_region:SetStartStaff(s.ItemNo)
            music_region:SetEndStaff(s.ItemNo)
            for noteentry in eachentry(music_region) do
                local nm = finale.FCNoteheadMod()
                nm:SetNoteEntry(noteentry)
                if nm:LoadFirst() then
                    if nm.FontName == "SFard" then
                        sf_staff = s.ItemNo
                    end
                end
            end
        end
        copy_music(sf_staff, inst_type)
    end
end

function check_and_run()
    local note_count = 0
    local music_region = finenv.Region()
    music_region:SetFullDocument()
    for noteentry in eachentrysaved(music_region) do
        if noteentry:IsNote() then
            note_count = note_count + 1
        end
    end

    if note_count == 0 then
        finenv.UI():AlertInfo("There don't appear to be any notes in your TAB staff.\n\nPlease enter notes before running this plug-in.", nil)
        return
    else
        local staff = finale.FCStaff()
        if staff:LoadFirst() then 
            if staff:GetNotationStyle() == 2 then
                local num_of_string = staff:CreateFretInstrumentDef()
                num_of_string:GetStringCount()
                create_SFard_instrument(num_of_string:GetStringCount())
            else
                local not_tab = finenv.UI():AlertInfo("Your first staff does not appear to be a TAB staff.\n\nPlease start with a TAB staff and try again.", "No TAB Staff Detected")
                return
            end
        end
    end
end

check_and_run()