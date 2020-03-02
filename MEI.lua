local music_region = finenv.Region()
music_region:SetFullDocument()
local staff_numbers = {}
local measure_numbers = {}

for staffs = 1, music_region:CalcStaffSpan() do
    table.insert(staff_numbers, staffs)
end

for measures = 1, music_region:GetEndMeasure() do
    table.insert(measure_numbers, measures)
end

local note_dur = {[4096] = 1, [6144] = 1, [2048] = 2, [3072] = 2, [1024] = 4, [1536] = 4}

local measure = finale.FCMeasure()
    for key, value in pairs(measure_numbers) do
        measure:Load(value)
        print("<measure label=\""..(value).."\" n=\""..(value+1).."\">")
        music_region:SetStartMeasure(value)
        music_region:SetEndMeasure(value)
        for addstaff = 1, staff_numbers[#staff_numbers] do
            music_region:SetStartStaff(addstaff)
            music_region:SetEndStaff(addstaff)
            print("<staff n=\""..addstaff.."\">")
            local layer_numbers = {false, false, false, false}
            for noteentry in eachentrysaved(music_region) do
                if noteentry:GetLayerNumber() == 1 then
                    layer_numbers[1] = true
                elseif noteentry:GetLayerNumber() == 2 then
                    layer_numbers[2] = true
                elseif noteentry:GetLayerNumber() == 3 then
                    layer_numbers[3] = true
                elseif noteentry:GetLayerNumber() == 2 then
                    layer_numbers[4] = true
                end
            end
            for k, v in pairs(layer_numbers) do
                if v == true then
                    print("<layer n=\""..k.."\">")
                    local note_count = 0
                    for noteentry in eachentrysaved(music_region) do
                        note_count = note_count + 1  
                    end
                    if note_count == 0 then
                        print("<mRest/>")
                    else
                        for noteentry in eachentrysaved(music_region) do
                            for note in each(noteentry) do
                                local dotted = ""
                                if noteentry:IsDotted() then
                                    dotted = (" dots=\""..noteentry:CalcDots().."\"")
                                end 
                                local key_sig = measure:GetKeySignature()
                                key_sig:LoadFirst()
                                local note_name = string.lower(note:CalcPitchChar())
                                local note_octave = note:CalcOctave(key_sig, 0)
                                local note_string = " dur=\""..note_dur[noteentry:GetDuration()].."\" dur.ges=\""..(noteentry:GetDuration() / 4).."p\" oct=\""..note_octave.."\" pname=\""..note_name.."\""
                                print("<note"..dotted..note_string..">")
                            end
                        end
                    end
                    print("</layer>")
                end
            end
        print("</staff>")
    end
    print("</measure>")
end