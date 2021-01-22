function plugindef()
    -- This function and the 'finaleplugin' namespace
    -- are both reserved for the plug-in definition.
    finaleplugin.RequireScore = true
    finaleplugin.Author = "Adrian Alvarez"
    finaleplugin.Version = "ver1"
    finaleplugin.Date = "03/17/2020"
    finaleplugin.AuthorEmail = "aalvarez@alfred.com"
    finaleplugin.CategoryTags = "Layout, Staff, System"
    return "101_Add BCB Staves", "101_Add BCB Staves", "Adds all the BCB staves to a document"
end

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

first_staff(finale.FFUUID_FLUTE, "Flutes", "Fls.", 0, {false})

for key, value in pairs(instruments_to_add) do
   add_staves(instruments_to_add[key][1], instruments_to_add[key][2], instruments_to_add[key][3], instruments_to_add[key][4], instruments_to_add[key][5]) 
end