function plugindef()
    -- This function and the 'finaleplugin' namespace
    -- are both reserved for the plug-in definition.
    finaleplugin.RequireScore = true
    finaleplugin.Author = "Adrian Alvarez"
    finaleplugin.Version = "ver1"
    finaleplugin.Date = "03/17/2020"
    finaleplugin.AuthorEmail = "aalvarez@alfred.com"
    finaleplugin.CategoryTags = "Layout, Staff, System"
    return "101_Add BCB Groups", "101_Add BCB Groups", "Adds all the BCB staves to a document"
end

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
group_prefs:GetHorizontalPos(-370)
group_prefs:GetVerticalPos(0)
group_prefs:SetAlignment(finale.TEXTHORIZALIGN_LEFT)
group_prefs:SetJustification(finale.TEXTJUSTIFY_LEFT)
group_prefs:SetExpandSingleWord(false)
group_prefs:Save()


function add_group(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33)
    local str = finale.FCString()
    str.LuaString = v1
    if string.find(v1, "||") then
        local i, j = string.find(v1, "||")
        str:SetCharacterAt(i-1, 32)
        str:SetCharacterAt(j-1, 13)
    end
    local group = finale.FCGroup()
    group:SaveNewFullNameBlock(str)
    str.LuaString = v2
    if string.find(v2, "||") then
        local i, j = string.find(v2, "||")
        str:SetCharacterAt(i-1, 32)
        str:SetCharacterAt(j-1, 13)
    end
    group:SaveNewAbbreviatedNameBlock(str)
    
    --group:HasFullName(v2)
    group:SetUseFullNamePositioning(v4)
    group:SetFullNameAlign(v5)
    group:SetFullNameExpandSingle(v6)
    group:SetFullNameHorizontalOffset(v7)
    --group:SetFullNameID(v8)
    group:SetFullNameJustify(v9)
    group:SetFullNameVerticalOffset(v10)

    --group:HasAbbreviatedName(v11)
    group:SetUseAbbreviatedNamePositioning(v12)
    group:SetAbbreviatedNameAlign(v13)
    group:SetAbbreviatedNameExpandSingle(v14)
    group:SetAbbreviatedNameHorizontalOffset(v15)
    --group:SetAbbreviatedNameID(v16)
    group:SetAbbreviatedNameJustify(v17)
    group:SetAbbreviatedNameVerticalOffset(v18)

    group:SetBarlineUse(v19)
    group:SetBarlineShapeID(v20)
    group:SetBracketHorizontalPos(v21)
    group:SetBracketSingleStaff(v22)
    group:SetBracketStyle(v23)
    group:SetBracketVerticalBottomPos(v24)
    group:SetBracketVerticalTopPos(v25)
    group:SetDrawBarlineMode(v26)
    group:SetEmptyStaffHide(v27)
    group:SetStartStaff(v28)
    group:SetEndStaff(v29)
    group:SetStartMeasure(v30)
    group:SetEndMeasure(v31)

    --group:SetItemID(v32)
    group:SetShowGroupName(v33)
    group:SaveNew(v32)
end

group_info = {
    {"01 Woodwinds", "01 Woodwinds", true, false, 0, false, -48, 224, 0, 0, true, false, 0, false, 0, 225, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 1, 3, 1, 32767, 1, false},
    {"02 Clarinets", "02 Clarinets", true, false, 0, false, -48, 232, 0, 0, true, false, 0, false, 0, 233, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 4, 5, 1, 32767, 2, false},
    {"02 Saxes", "02 Saxes", true, false, 0, false, -48, 226, 0, 0, true, false, 0, false, 0, 227, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 7, 9, 1, 32767, 3, false},
    {"03 Brass", "03 Brass", true, false, 0, false, -48, 228, 0, 0, true, false, 0, false, 0, 229, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 14, 17, 1, 32767, 4, false},
    {"04 Percussion", "04 Percussion", true, false, 0, false, -48, 230, 0, 0, true, false, 0, false, 0, 231, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 18, 21, 1, 32767, 5, false},    
    {"Flutes", "Fls.", true, false, 0, false, -48, 193, 0, 0, true, false, 0, false, 0, 194, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 1, 1, 1, 32767, 6, true},
    {"1||2", "1||2", true, true, 1, false, -60, 264, 1, 0, true, true, 1, false, -60, 265, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 1, 1, 1, 32767, 7, true},
    {"Oboe", "Ob.", true, false, 0, false, -48, 195, 0, 0, true, false, 0, false, 0, 196, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 2, 2, 1, 32767, 8, true},
    {"Bassoon", "Bsn.", true, false, 0, false, -48, 238, 0, 0, true, false, 0, false, 0, 239, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 3, 3, 1, 32767, 9, true},
    {"B^flat() Clarinets", "Cls.", true, false, 0, false, -48, 197, 0, 0, true, false, 0, false, 0, 198, 0, 0, false, 0, -38, false, 8, 0, 0, 2, 0, 4, 5, 1, 32767, 10, true},
    {"1", "1", true, true, 1, false, -60, 234, 1, 0, true, true, 1, false, -60, 235, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 4, 4, 1, 32767, 11, true},
    {"2||3", "2||3", true, true, 1, false, -60, 236, 1, 0, true, true, 1, false, -60, 237, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 5, 5, 1, 32767, 12, true},
    {"B^flat() Bass Clarinet", "B. Cl.", true, false, 0, false, -48, 199, 0, 0, true, false, 0, false, 0, 200, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 6, 6, 1, 32767, 13, true},
    {"E^flat() Alto||Saxophones", "A. Saxes.", true, false, 0, false, -48, 201, 0, 0, true, false, 0, false, 0, 202, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 7, 7, 1, 32767, 14, true},
    {"1||2", "1||2", true, true, 1, false, -60, 266, 1, 0, true, true, 1, false, -60, 267, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 7, 7, 1, 32767, 15, true},
    {"B^flat() Tenor||Saxophone", "T. Sax.", true, false, 0, false, -48, 203, 0, 0, true, false, 0, false, 0, 204, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 8, 8, 1, 32767, 16, true},
    {"E^flat() Baritone||Saxophone", "Bar. Sax.", true, false, 0, false, -48, 205, 0, 0, true, false, 0, false, 0, 206, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 9, 9, 1, 32767, 17, true},
    {"B^flat() Trumpets", "Tpts.", true, false, 0, false, -48, 207, 0, 0, true, false, 0, false, 0, 208, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 10, 11, 1, 32767, 18, true},
    {"1", "1", true, true, 1, false, -60, 240, 1, 0, true, true, 1, false, -60, 241, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 10, 10, 1, 32767, 19, true},
    {"2||3", "2||3", true, true, 1, false, -60, 242, 1, 0, true, true, 1, false, -60, 243, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 11, 11, 1, 32767, 20, true},
    {"F Horns", "Hns.", true, false, 0, false, -48, 209, 0, 0, true, false, 0, false, 0, 210, 0, 0, false, 0, -18, false, 6, 0, 0, 2, 0, 12, 13, 1, 32767, 21, true},
    {"1", "1", true, true, 1, false, -60, 274, 1, 0, true, true, 1, false, -60, 275, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 12, 12, 1, 32767, 22, true},
    {"2", "2", true, true, 1, false, -60, 276, 1, 0, true, true, 1, false, -60, 277, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 13, 13, 1, 32767, 23, true},
    {"Trombones", "Tbns.", true, false, 0, false, -48, 211, 0, 0, true, false, 0, false, 0, 212, 0, 0, false, 0, -38, false, 8, 0, 0, 2, 0, 14, 15, 1, 32767, 24, true},
    {"1||2", "1||2", true, true, 1, false, -60, 278, 1, 0, true, true, 1, false, -60, 279, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 14, 14, 1, 32767, 37, true},
    {"3", "3", true, true, 1, false, -60, 280, 1, 0, true, true, 1, false, -60, 281, 1, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 15, 15, 1, 32767, 25, true},
    {"Euphonium", "Euph.", true, false, 0, false, -48, 244, 0, 0, true, false, 0, false, 0, 245, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 16, 16, 1, 32767, 26, true},
    {"Tuba", "Tuba", true, false, 0, false, -48, 213, 0, 0, true, false, 0, false, 0, 214, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 17, 17, 1, 32767, 27, true},
    {"Mallet Percussion||(Instrument, Instrument)", "Mlt. Perc.", true, false, 0, false, -48, 215, 0, 0, true, false, 0, false, 0, 216, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 18, 18, 1, 32767, 28, true},
    {"Timpani", "Timp.", true, false, 0, false, -48, 217, 0, 0, true, false, 0, false, 0, 218, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 19, 19, 1, 32767, 29, true},
    {"Percussion 1||(Instrument, Instrument)", "Perc. 1", true, false, 0, false, -48, 219, 0, 0, true, false, 0, false, 0, 220, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 20, 20, 1, 32767, 30, true},
    {"Percussion 2||(Instrument, Instrument)", "Perc. 2", true, false, 0, false, -48, 221, 0, 0, true, false, 0, false, 0, 222, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 21, 21, 1, 32767, 31, true},
    {"Percussion 3||(Instrument, Instrument)", "Perc. 3", true, false, 0, false, -48, 246, 0, 0, true, false, 0, false, 0, 247, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 22, 22, 1, 32767, 32, true},
    {"E≤ Alto Clarinet", "E≤ A. Cl.", true, false, 0, false, -48, 282, 0, 0, true, false, 0, false, 0, 283, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 23, 23, 1, 32767, 33, true},
    {"Electric Bass", "Elec. Bass", true, false, 0, false, -48, 284, 0, 0, true, false, 0, false, 0, 285, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 24, 24, 1, 32767, 34, true},
    {"Pno. T.C.", "Pno. T.C.", true, false, 0, false, -48, 248, 0, 0, true, false, 0, false, 0, 249, 0, 0, false, 0, -12, false, 0, 0, 0, 2, 0, 25, 25, 1, 32767, 35, false},
    {"Piano", "Pno.", true, false, 0, false, -48, 260, 0, 0, true, false, 0, false, 0, 261, 0, 0, false, 0, -12, false, 3, 0, 0, 2, 1, 25, 26, 1, 32767, 26, true}
}

for key, value in pairs(group_info) do
    add_group(group_info[key][1], group_info[key][2], group_info[key][3], group_info[key][4], group_info[key][5], group_info[key][6], group_info[key][7], group_info[key][8], group_info[key][9], group_info[key][10],
group_info[key][11], group_info[key][12], group_info[key][13], group_info[key][14], group_info[key][15], group_info[key][16], group_info[key][17], group_info[key][18], group_info[key][19], group_info[key][20],
group_info[key][21], group_info[key][22], group_info[key][23], group_info[key][24], group_info[key][25], group_info[key][26], group_info[key][27], group_info[key][28], group_info[key][29], group_info[key][30],
group_info[key][31], group_info[key][32], group_info[key][33])
end