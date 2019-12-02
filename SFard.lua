function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2019 CJ Garcia Music"
    finaleplugin.Version = "0.9"
    finaleplugin.Date = "11/30/2019"
    return "SFard Notation", "SFard Notation", "Converts the document from tab to SFard block notation"
end

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
            sys:SetStaffHeight( 198 * 64)
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
                for i = 1, 4 do
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
                for i = 1, 4 do
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
                for i = 1, 4 do
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
                for i = 1, 4 do
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
                for i = 1, 4 do
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

function transpose_music(sfard_staff)
    for noteentry in eachentrysaved(sfard_staff) do
        local tnm = finale.FCTablatureNoteMod()
        tnm:SetNoteEntry(noteentry)
        for note in each(noteentry) do
            if note:CalcMIDIKey() == 40 then
                note:SetMIDIKey(0)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note)
            elseif note:CalcMIDIKey() == 41 then
                note:SetMIDIKey(1)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 42 then
                note:SetMIDIKey(2)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 43 then
                note:SetMIDIKey(3)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note) 
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 44 then
                note:SetMIDIKey(4)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(6)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 45 then
                note:SetMIDIKey(0)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note)
            elseif note:CalcMIDIKey() == 46 then
                note:SetMIDIKey(1)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 47 then
                note:SetMIDIKey(2)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 48 then
                note:SetMIDIKey(3)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note) 
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 49 then
                note:SetMIDIKey(4)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(5)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 50 then
                note:SetMIDIKey(0)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note)
            elseif note:CalcMIDIKey() == 51 then
                note:SetMIDIKey(1)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 52 then
                note:SetMIDIKey(2)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 53 then
                note:SetMIDIKey(3)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note) 
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 54 then
                note:SetMIDIKey(4)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(4)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 55 then
                note:SetMIDIKey(0)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note)
            elseif note:CalcMIDIKey() == 56 then
                note:SetMIDIKey(1)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 57 then
                note:SetMIDIKey(2)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 58 then
                note:SetMIDIKey(3)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note) 
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(3)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 59 then
                note:SetMIDIKey(0)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 60 then
                note:SetMIDIKey(1)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 61 then
                note:SetMIDIKey(2)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 62 then
                note:SetMIDIKey(3)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 63 then
                note:SetMIDIKey(4)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(2)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 64 then
                note:SetMIDIKey(0)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note)
            elseif note:CalcMIDIKey() == 65 then
                note:SetMIDIKey(1)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 66 then
                note:SetMIDIKey(2)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 67 then
                note:SetMIDIKey(3)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note_boarder)
            elseif note:CalcMIDIKey() == 68 then
                note:SetMIDIKey(4)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note)
                local note_boarder = noteentry:AddNewNote()
                note_boarder:SetMIDIKey(0)
                tnm:SetStringNumber(1)
                tnm:SaveAt(note_boarder)
            end
        end
    end
end

function copy_music(bottom_staff)
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
     
    topregion.StartStaff = bottom_staff
    topregion.EndStaff = bottom_staff
    topregion:PasteMusic()

    topregion:ReleaseMusic()
     
    region:SetInDocument()

    transpose_music(bottomregion)
    set_shapes(bottomregion)
end

function create_shape_staff(tab_staff)
    local staffID = finale.FCStaves.Append()
    local staff = finale.FCStaff()
    local shape_staff = 0
    local efix32 = 64
    if staffID then
        staff:Load(staffID)
        staff:IsTablature(true)
        staff:SetNotationStyle(finale.STAFFNOTATION_TABLATURE)
        staff.InstrumentUUID = "1e1303c5-779b-4b96-ae9a-a15319434056"
        staff:SetFretInstrumentDefID(tab_staff)
        staff:SetBreakTablatureLines(false)
        staff:SetFretLetters(false)
        staff:SetLowestFret(0)
        staff:SetVerticalFretOffset(-12 * efix32)
        staff:SetShowFretboards(false)
        staff:SetLineCount(6)
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
        string.LuaString = "Shape Tab"
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
    copy_music(shape_staff)
end

function create_SFard_instrument()
    local ui = finenv.UI()
    ui:MenuCommand(finale.MENUCMD_VIEWPAGEVIEW)
    ui:MenuCommand(finale.MENUCMD_EDITSCORE)

    local tab_staves = finale.FCFretInstrumentDefs()
    tab_staves:LoadAll()
    local sf_itemno = 0
    local count = 0
    for ts in each(tab_staves) do
        count = count + 1
        if ts:GetStringTuning(1) == 0 then
            if ts:GetStringTuning(2) == 0 then
                if ts:GetStringTuning(3) == 0 then
                    if ts:GetStringTuning(4) == 0 then
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
    if sf_itemno == 0 then
        local tab_staff = finale.FCFretInstrumentDef()
        tab_staff:Load(1)
        local string = finale.FCString()
        string.LuaString = "SFard"
        tab_staff:SetName(string)
        for i = 1, 6 do
            tab_staff:SetStringTuning(i, 0)
        end
        tab_staff:SaveNew()
        create_shape_staff(tab_staff:GetItemNo())
    else
        local staves = finale.FCStaves()
        staves:LoadAll()
        local sf_staff = 0
        for s in each(staves) do
            local music_region = finenv.Region()
            music_region:SetFullDocument()
            music_region:SetStartStaff(s.ItemNo)
            music_region:SetEndStaff(s.ItemNo)
            for noteentry in eachentry(finenv.Region()) do
                local nm = finale.FCNoteheadMod()
                nm:SetNoteEntry(noteentry)
                if nm:LoadFirst() then
                    if nm.FontName == "SFard" then
                        sf_staff = s.ItemNo
                    end
                end
            end
        end
        copy_music(sf_staff)
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
                create_SFard_instrument()
            else
                local not_tab = finenv.UI():AlertYesNo("Your first staff does not appear to be a TAB staff, are you sure you want to continue?\n\nContinuing may have adverse results.", "No TAB Staff Detected")
                if not_tab == 2 then
                    create_SFard_instrument()
                else
                    return
                end
            end
        end
    end
end

check_and_run()