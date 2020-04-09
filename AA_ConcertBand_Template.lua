function plugindef()
    finaleplugin.RequireScore = true
    finaleplugin.Author = "Adrian Alvarez and CJ Garcia"
    finaleplugin.Version = "0.5"
    finaleplugin.Date = "03/25/2020"
    finaleplugin.AuthorEmail = "aalvarez@alfred.com, cgarcia@makemusic.com"
    finaleplugin.CategoryTags = "Layout, Staff, System, Group, Page"
    return "101_BCB Full Template", "101_BCB Full Template", "Creates the BCB template from a new document without libraries."
end

function set_page_prefs(first_sys, second_sys, scale_settings, page_settings)
    local page_prefs = finale.FCPageFormatPrefs()
    page_prefs:LoadScore()
    page_prefs:SetUseFacingPages(false)
    page_prefs:SetUseFirstSystemMargins(first_sys[1])
    page_prefs:SetFirstSystemTop(first_sys[2])
    page_prefs:SetFirstSystemDistance(first_sys[3])
    page_prefs:SetFirstSystemLeft(first_sys[4])

    page_prefs:SetSystemTop(second_sys[1])
    page_prefs:SetSystemDistanceBetween(0 - second_sys[2])
    page_prefs:SetSystemLeft(second_sys[3])
    page_prefs:SetSystemRight(second_sys[4])
    page_prefs:SetSystemBottom(second_sys[5])

    page_prefs:SetSystemScaling(scale_settings[1])
    page_prefs:SetSystemStaffHeight(scale_settings[2] * 16)
    page_prefs:SetPageScaling(scale_settings[3])

    page_prefs:SetPageHeight(page_settings[1])
    page_prefs:SetPageWidth(page_settings[2])
    page_prefs:SetLeftPageLeftMargin(page_settings[3])
    page_prefs:SetLeftPageRightMargin(page_settings[4])
    page_prefs:SetLeftPageTopMargin(page_settings[5])
    page_prefs:SetLeftPageBottomMargin(page_settings[6])
    page_prefs:Save()
end

function set_pages(page_settings)
    local page = finale.FCPage()
    page:Load(1)
    page:SetHeight(page_settings[1][1])
    page:SetWidth(page_settings[1][2])
    page:SetLeftMargin(page_settings[1][3])
    page:SetRightMargin(page_settings[1][4])
    page:SetTopMargin(page_settings[1][5])
    page:SetBottomMargin(page_settings[1][6])
    page:SetPercent(page_settings[1][7])
    page:Save()
    for i = 2, 100 do
        page:Load(i)
        page:SetHeight(page_settings[2][1])
        page:SetWidth(page_settings[2][2])
        page:SetLeftMargin(page_settings[2][3])
        page:SetRightMargin(page_settings[2][4])
        page:SetTopMargin(page_settings[2][5])
        page:SetBottomMargin(page_settings[2][6])
        page:SetPercent(page_settings[2][7])
        page:Save()
    end
end

function redefine_systems(first_sys, second_sys, sys_scale)
    local staffsystems = finale.FCStaffSystems()
    staffsystems:LoadAll()
    for ss in each(staffsystems) do
        ss:SetResize(sys_scale[1])
        ss:SetStaffHeight(sys_scale[2] * 64)
        ss:Save()
        if ss:GetItemNo() == 1 then
            ss:SetTopMargin(first_sys[2])
            ss:SetBottomMargin(second_sys[4])
            ss:SetSpaceAbove(first_sys[3])
            ss:SetLeftMargin(first_sys[4])
            ss:Save()
        else
            ss:SetTopMargin(second_sys[1])
            ss:SetSpaceAbove(second_sys[2])
            ss:SetLeftMargin(second_sys[3])
            ss:SetRightMargin(second_sys[4])
            ss:SetBottomMargin(second_sys[5])
            ss:Save()
        end
    end
end

function staff_distances(first_distance, first_hidden, second_distance, second_hidden)
    for i = 1, 100 do
        local start_distance = 0
        local new_distance = second_distance
        if i == 1 then
            new_distance = first_distance
        end
        local sysstaves = finale.FCSystemStaves()
        sysstaves:LoadAllForItem(i)
        for sysstaff in each(sysstaves) do
            if sysstaff:GetStaff() >= 22 then
                if i == 1 then
                    sysstaff:SetDistance(start_distance + first_hidden)
                else
                    sysstaff:SetDistance(start_distance + second_hidden)
                end
            else
                sysstaff:SetDistance(start_distance)
            end
            start_distance = start_distance + new_distance
            sysstaff:Save()
        end
    end
end

function page_text(the_text, hori_align, vert_align, hori_just, hori_pos, vert_pos, first_page, last_page, visible)
    local stringobject = finale.FCString()
    stringobject.LuaString = the_text

    if string.find(stringobject.LuaString, "|") then
        local i, j = string.find(stringobject.LuaString, "|")
        if string.find(stringobject.LuaString, "ASCAP") then
            stringobject:SetCharacterAt(i-3, 13)
        elseif string.find(stringobject.LuaString, "©") then
            for w in string.gmatch(stringobject.LuaString, "|") do
               local a, b = string.find(stringobject.LuaString, "|")
               stringobject:SetCharacterAt(a-2, 13)
            end
        else
            stringobject:SetCharacterAt(i-1, 13)
        end
    end

    local pagetext = finale.FCPageText()
    pagetext.HorizontalAlignment = hori_align
    pagetext.VerticalAlignment = vert_align
    pagetext.HorizontalPos = hori_pos
    pagetext.VerticalPos = vert_pos
    pagetext.Visible = visible
    pagetext.FirstPage = first_page
    pagetext.LastPage = last_page
    pagetext:SaveNewTextBlock(stringobject)
    pagetext:SaveNew(1)

    local text_block = pagetext:CreateTextBlock()
    text_block.Justification = hori_just
    text_block:Save()
end

function first_staff(inst_UUID, inst_full_name, inst_abbr_name, clef_num, transpose_settings)
    local staff = finale.FCStaff()
    staff:LoadFirst()
    staff.InstrumentUUID = inst_UUID
    staff.DefaultClef = clef_num
    local str = finale.FCString()
    str.LuaString = inst_full_name
    staff:SaveNewFullNameString(str)
    str.LuaString = inst_abbr_name
    staff:SaveNewAbbreviatedNameString(str)
    if inst_UUID == finale.FFUUID_PERCUSSIONGENERAL then
        staff:SetNotationStyle(finale.STAFFNOTATION_PERCUSSION)
        staff:SavePercussionLayout(1, 0)
    end
    if transpose_settings[1] == true then
        staff:SetTransposeInterval(transpose_settings[2])
        staff:SetTransposeAlteration(transpose_settings[3])
        if transpose_settings[4] ~= nil then
            staff:SetTransposeUseClef(true)
            staff:SetTransposeClefIndex(transpose_settings[5])
        end
    end
    staff:SetShowScoreStaffNames(false)
    staff:Save()
end

function add_staves(inst_UUID, inst_full_name, inst_abbr_name, clef_num, transpose_settings)
    if inst_UUID ~= finale.FFUUID_PIANO then
        local staffID = finale.FCStaves.Append()
        if staffID then
            local staff = finale.FCStaff()
            staff:Load(staffID)
            staff.InstrumentUUID = inst_UUID
            staff.DefaultClef = clef_num
            local str = finale.FCString()
            str.LuaString = inst_full_name
            staff:SaveNewFullNameString(str)
            str.LuaString = inst_abbr_name
            staff:SaveNewAbbreviatedNameString(str)
            if inst_UUID == finale.FFUUID_PERCUSSIONGENERAL then
                staff:SetNotationStyle(finale.STAFFNOTATION_PERCUSSION)
                staff:SavePercussionLayout(1, 0)
            end
            if transpose_settings[1] == true then
                staff:SetTransposeInterval(transpose_settings[2])
                staff:SetTransposeAlteration(transpose_settings[3])
                if transpose_settings[4] ~= nil then
                    staff:SetTransposeUseClef(true)
                    staff:SetTransposeClefIndex(transpose_settings[5])
                end
            end
            staff:SetShowScoreStaffNames(false)
            staff:Save()    
        end
    elseif inst_UUID == finale.FFUUID_PIANO then
        local staff = finale.FCStaff()
        local piano_settings = {}
        local staffID1 = finale.FCStaves.Append()
        table.insert(piano_settings, staffID1)
        local staffID2 = finale.FCStaves.Append()
        table.insert(piano_settings, staffID2)

        for k, v in pairs(piano_settings) do
            staff:Load(v)
            staff.InstrumentUUID = inst_UUID
            staff.DefaultClef = clef_num[k]
            local str = finale.FCString()
            str.LuaString = inst_full_name
            staff:SaveNewFullNameString(str)
            str.LuaString = inst_abbr_name
            staff:SaveNewAbbreviatedNameString(str)
            staff:SetShowScoreStaffNames(false)
            staff:Save() 
        end 
    end
end

function set_font_prefs(group_type, name, size, style)
    for key, value in pairs(group_type) do
        local fonti = finale.FCFontInfo()
        fonti:SetName("Times Bold")
        fonti:SetSize(16)
        fonti:SetPlain(style[1])
        fonti:SetBold(style[2])
        fonti:SetItalic(style[3])
        fonti:SetUnderline(style[4])
        fonti:SetAbsolute(style[5])
        fonti:SaveFontPrefs(value)
    end
end

function set_group_prefs()
    local group_prefs = finale.FCGroupNamePositionPrefs()

    group_prefs:LoadFirst()
    group_prefs:LoadFull()
    group_prefs:SetHorizontalPos(-580)
    group_prefs:SetVerticalPos(0)
    group_prefs:SetAlignment(finale.TEXTHORIZALIGN_LEFT)
    group_prefs:SetJustification(finale.TEXTJUSTIFY_LEFT)
    group_prefs:SetExpandSingleWord(false)
    group_prefs:Save()
    group_prefs:LoadAbbreviated()
    group_prefs:SetHorizontalPos(-370)
    group_prefs:SetVerticalPos(0)
    group_prefs:SetAlignment(finale.TEXTHORIZALIGN_LEFT)
    group_prefs:SetJustification(finale.TEXTJUSTIFY_LEFT)
    group_prefs:SetExpandSingleWord(false)
    group_prefs:Save()
end


function add_group(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29)
    local full_str = finale.FCString()
    full_str.LuaString = "^font(Times Bold,4096)^size(16)^nfx(0)"..v1
    if string.find(full_str.LuaString, "||") then
        local i, j = string.find(full_str.LuaString, "||")
        full_str:SetCharacterAt(i-1, 32)
        full_str:SetCharacterAt(j-1, 13)
    end
    if string.find(full_str.LuaString, "%(Instrument, Instrument%)") then
        full_str.LuaString = string.gsub(full_str.LuaString, "%(Instrument, Instrument%)", "^font(Times Bold,4096)^size(12)^nfx(0)(Instrument, Instrument)")
    end

    local group = finale.FCGroup()
    group:SaveNewFullNameBlock(full_str)

    local abbr_str = finale.FCString()
    abbr_str.LuaString = "^font(Times Bold,4096)^size(16)^nfx(0)"..v2
    if string.find(abbr_str.LuaString, "||") then
        local i, j = string.find(abbr_str.LuaString, "||")
        abbr_str:SetCharacterAt(i-1, 32)
        abbr_str:SetCharacterAt(j-1, 13)
    end
    group:SaveNewAbbreviatedNameBlock(abbr_str)
    group:SetUseFullNamePositioning(v3)
    group:SetFullNameAlign(v4)
    group:SetFullNameExpandSingle(v5)
    group:SetFullNameHorizontalOffset(v6)
    group:SetFullNameJustify(v7)
    group:SetFullNameVerticalOffset(v8)

    group:SetUseAbbreviatedNamePositioning(v9)
    group:SetAbbreviatedNameAlign(v10)
    group:SetAbbreviatedNameExpandSingle(v11)
    group:SetAbbreviatedNameHorizontalOffset(v12)
    group:SetAbbreviatedNameJustify(v13)
    group:SetAbbreviatedNameVerticalOffset(v14)

    group:SetBarlineUse(v15)
    group:SetBarlineShapeID(v16)
    group:SetBracketHorizontalPos(v17)
    group:SetBracketSingleStaff(v18)
    group:SetBracketStyle(v19)
    group:SetBracketVerticalBottomPos(v20)
    group:SetBracketVerticalTopPos(v21)
    group:SetDrawBarlineMode(v22)
    group:SetEmptyStaffHide(v23)
    group:SetStartStaff(v24)
    group:SetEndStaff(v25)
    group:SetStartMeasure(v26)
    group:SetEndMeasure(v27)

    group:SetShowGroupName(v29)
    group:SaveNew(v28)
end

-- full name (FN), abbr name (AN), use FN pos?, FN align, FN expand, FN hori pos, FN justification, FN vert pos, use AN pos?, AN align, AN expand, AN hori pos, AN justification, AN vert pos,
--use barline?, barline shape ID, bracket hori pos, bracket single staff?, bracket style, bracket bottom pos, bracket top pos, barline mode, empty staff hide, start staff, end staff, start measure, end measure, save new, show name?
local group_info = {
    {"01 Woodwinds", "01 Woodwinds", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 1, 3, 1, 32767, 1, false},
    {"02 Clarinets", "02 Clarinets", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 4, 6, 1, 32767, 2, false},
    {"02 Saxes", "02 Saxes", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 7, 9, 1, 32767, 3, false},
    {"03 Brass", "03 Brass", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 14, 17, 1, 32767, 4, false},
    {"04 Percussion", "04 Percussion", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 18, 21, 1, 32767, 5, false},    
    {"Flutes", "Fls.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 1, 1, 1, 32767, 6, true},
    {"1||2", "1||2", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 1, 1, 1, 32767, 7, true},
    {"Oboe", "Ob.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 2, 2, 1, 32767, 8, true},
    {"Bassoon", "Bsn.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 3, 3, 1, 32767, 9, true},
    {"B^flat() Clarinets", "Cls.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -38, false, 8, 0, 0, 2, 0, 4, 5, 1, 32767, 10, true},
    {"1", "1", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 4, 4, 1, 32767, 11, true},
    {"2||3", "2||3", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 5, 5, 1, 32767, 12, true},
    {"B^flat() Bass Clarinet", "B. Cl.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 6, 6, 1, 32767, 13, true},
    {"E^flat() Alto||Saxophones", "A. Saxes.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 7, 7, 1, 32767, 14, true},
    {"1||2", "1||2", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 7, 7, 1, 32767, 15, true},
    {"B^flat() Tenor||Saxophone", "T. Sax.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 8, 8, 1, 32767, 16, true},
    {"E^flat() Baritone||Saxophone", "Bar. Sax.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 9, 9, 1, 32767, 17, true},
    {"B^flat() Trumpets", "Tpts.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 10, 11, 1, 32767, 18, true},
    {"1", "1", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 10, 10, 1, 32767, 19, true},
    {"2||3", "2||3", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 11, 11, 1, 32767, 20, true},
    {"F Horns", "Hns.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 12, 13, 1, 32767, 21, true},
    {"1", "1", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 12, 12, 1, 32767, 22, true},
    {"2", "2", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 13, 13, 1, 32767, 23, true},
    {"Trombones", "Tbns.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -38, false, 8, 0, 0, 2, 0, 14, 15, 1, 32767, 24, true},
    {"1||2", "1||2", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 14, 14, 1, 32767, 37, true},
    {"3", "3", true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, true, finale.TEXTHORIZALIGN_RIGHT, false, -90, finale.TEXTJUSTIFY_RIGHT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 15, 15, 1, 32767, 25, true},
    {"Euphonium", "Euph.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 16, 16, 1, 32767, 26, true},
    {"Tuba", "Tuba", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 17, 17, 1, 32767, 27, true},
    {"Mallet Percussion||(Instrument, Instrument)", "Mlt. Perc.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 18, 18, 1, 32767, 28, true},
    {"Timpani", "Timp.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 19, 19, 1, 32767, 29, true},
    {"Percussion 1||(Instrument, Instrument)", "Perc. 1", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 20, 20, 1, 32767, 30, true},
    {"Percussion 2||(Instrument, Instrument)", "Perc. 2", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 21, 21, 1, 32767, 31, true},
    {"Percussion 3||(Instrument, Instrument)", "Perc. 3", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 22, 22, 1, 32767, 32, true},
    {"E^flat() Alto Clarinet", "E^flat() A. Cl.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 23, 23, 1, 32767, 33, true},
    {"Electric Bass", "Elec. Bass", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 24, 24, 1, 32767, 34, true},
    {"Pno. T.C.", "Pno. T.C.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 25, 25, 1, 32767, 35, false},
    {"Piano", "Pno.", false, finale.TEXTHORIZALIGN_LEFT, false, -48, finale.TEXTJUSTIFY_LEFT, 0, false, finale.TEXTHORIZALIGN_LEFT, false, 0, finale.TEXTJUSTIFY_LEFT, 0, false, 0, -12, false, 3, 0, 0, 2, 1, 25, 26, 1, 32767, 26, true}
}

--instrument UUID, Full Name, Abbr Name, clef num, {uses transposition?, interval, alteration, use tranpose clef?, clef index}
local instruments_to_add = {
{finale.FFUUID_OBOE, "Oboe", "Ob.", 0, {false}},
{finale.FFUUID_BASSOON, "Bassoon", "Bsn.", 3, {false}},
{finale.FFUUID_CLARINETBFLAT, "B^flat() Clarinet 1", "Cl. 1", 0, {true, 1, 2}},
{finale.FFUUID_CLARINETBFLAT, "B^flat() Clarinets 2/3", "Cls. 2/3", 0, {true, 1, 2}},
{finale.FFUUID_BASSCLARINET, "B^flat() Bass Clarinet", "B.Cl.", 0, {true, 8, 2, true, 0}},
{finale.FFUUID_ALTOSAX, "E^flat() Alto Saxophones 1/2", "A.Saxes. 1/2", 0, {true, 5, 3}},
{finale.FFUUID_TENORSAX, "B^flat() Tenor Saxophone", "T.Sax.", 0, {true, 8, 2, true, 0}},
{finale.FFUUID_BARITONESAX, "E^flat() Bartione Saxophone", "Bar.Sax.", 0, {true, 12, 3, true, 0}},
{finale.FFUUID_TRUMPETBFLAT, "B^flat() Trumpet 1", "Tpt. 1", 0, {true, 1, 2}},
{finale.FFUUID_TRUMPETBFLAT, "B^flat() Trumpets 2/3", "Tpts. 2/3", 0, {true, 1, 2}},
{finale.FFUUID_HORNF, "F Horn 1", "Hn. 1", 0, {true, 4, 1}},
{finale.FFUUID_HORNF, "F Horn 2", "Hn. 2", 0, {true, 4, 1}},
{finale.FFUUID_TROMBONE, "Trombones 1/2", "Tbns. 1/2", 3, {false}},
{finale.FFUUID_TROMBONE, "Trombone 3", "Tbn. 3", 3, {false}},
{finale.FFUUID_EUPHONIUM, "Euphonium", "Euph.", 3, {false}},
{finale.FFUUID_TUBA, "Tuba", "Tuba", 3, {false}},
{finale.FFUUID_MALLETS, "Mallets", "Mlt. Perc.", 0, {false}},
{finale.FFUUID_TIMPANI, "Timpani", "Timp.", 3, {false}},
{finale.FFUUID_PERCUSSIONGENERAL, "Percussion 1", "Perc. 1", 12, {false}},
{finale.FFUUID_PERCUSSIONGENERAL, "Percussion 2", "Perc. 2", 12, {false}},
{finale.FFUUID_PERCUSSIONGENERAL, "Percussion 3", "Perc. 3", 12, {false}},
{finale.FFUUID_ALTOCLARINET, "Alto Clarinet", "A.Cl.", 0, {true, 5, 3}},
{finale.FFUUID_ELECTRICBASS, "Electric Bass", "E.B", 3, {true, 7, 0}},
{finale.FFUUID_PIANO, "Piano", "Pno.", {0, 3}, {false}}
}

first_staff(finale.FFUUID_FLUTE, "Flutes", "Fls.", 0, {false})

for key, value in pairs(instruments_to_add) do
   add_staves(instruments_to_add[key][1], instruments_to_add[key][2], instruments_to_add[key][3], instruments_to_add[key][4], instruments_to_add[key][5]) 
end

--{font preferences to change}, font name, font size, {plain?, bold?, italic?, underline?, fixed?}
set_font_prefs({finale.FONTPREF_GROUPNAME, finale.FONTPREF_ABRVGROUPNAME}, "Times Bold", 16, {true, false, false, false, false})

set_group_prefs()

for key, value in pairs(group_info) do
    add_group(group_info[key][1], group_info[key][2], group_info[key][3], group_info[key][4], group_info[key][5], group_info[key][6], group_info[key][7], group_info[key][8], group_info[key][9], group_info[key][10],
group_info[key][11], group_info[key][12], group_info[key][13], group_info[key][14], group_info[key][15], group_info[key][16], group_info[key][17], group_info[key][18], group_info[key][19], group_info[key][20],
group_info[key][21], group_info[key][22], group_info[key][23], group_info[key][24], group_info[key][25], group_info[key][26], group_info[key][27], group_info[key][28], group_info[key][29])
end

--height, width, left, right, top, bottom, page percent
local first_page_settings = {3456, 2592, 177, 177, 115, 101, 100}
local second_page_settings = {3456, 2592, 177, 177, 115, 101, 100}
set_pages({first_page_settings, second_page_settings})

--scale syste, staff heigh, scale page
local scale_settings = {96, 57, 100}

--use first system, top margin, distance between, right margin
local first_sys_settings = {true, 84, 228, 332}

--top, distance, left, right, bottom + 96
local second_sys_settings = {84, 48, 212, 0, (84) + 96}

set_page_prefs(first_sys_settings, second_sys_settings, scale_settings, first_page_settings)

redefine_systems(first_sys_settings, second_sys_settings, scale_settings)

--distance between on first page, distance to shove staves off first page, distance between on second page, distance to shove staves of seccond page
staff_distances(234, 438, 258, 282)

--text enigma syntax, horizontal alignment, vertical alignment, justification, horizontal position, vertical position, first page, last page, visible
page_text("^font(Times,4096)^size(10)^nfx(64)Dedication", finale.TEXTHORIZALIGN_CENTER, finale.TEXTVERTALIGN_TOP, finale.TEXTJUSTIFY_CENTER, 0, 0, 1, 1, true)
page_text("^font(Times Bold,4096)^size(24)^nfx(64)Title|^font(Times,4096)^size(11)Subtitle", finale.TEXTHORIZALIGN_CENTER, finale.TEXTVERTALIGN_TOP, finale.TEXTJUSTIFY_CENTER, 0, -32, 1, 1, true)
page_text("^font(MaestroTimes,4096)^size(11)^nfx(64)^partname() - ^page(0)", finale.TEXTHORIZALIGN_LEFT, finale.TEXTVERTALIGN_TOP, finale.TEXTJUSTIFY_LEFT, 0, -138, 1, 1, true)
page_text("^font(Times,4096)^size(11)^nfx(64)Approx. Duration - ?:??", finale.TEXTHORIZALIGN_LEFT, finale.TEXTVERTALIGN_TOP, finale.TEXTJUSTIFY_LEFT, 0, -208, 1, 1, true)
page_text("^font(Times,4096)^size(11)^nfx(64)Composer’s Name in u/l (ASCAP)|^font(Times Italic,4096)Arranged by Name in u/l", finale.TEXTHORIZALIGN_RIGHT, finale.TEXTVERTALIGN_TOP, finale.TEXTJUSTIFY_RIGHT, 0, -165, 1, 1, true)
page_text("^font(Times,4096)^size(10)^nfx(64)?????", finale.TEXTHORIZALIGN_LEFT, finale.TEXTVERTALIGN_BOTTOM, finale.TEXTJUSTIFY_CENTER, 0, 0, 1, 1, true)
page_text("^font(Times,4096)^size(8)^nfx(64)© 20?? COMPANY NAMES ALL CAPS,|a division of ALFRED MUSIC|All Rights Reserved including Public Performance", finale.TEXTHORIZALIGN_CENTER, finale.TEXTVERTALIGN_BOTTOM, finale.TEXTJUSTIFY_CENTER, 0, 0, 1, 1, true)