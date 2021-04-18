from mido import MidiFile

path = "/_Source/391/391_build/391_t200.mid"

mid = MidiFile(path)

offset = 480
beat = 480
numerator = 0
denominator = 0

# conductor track
for msg in mid.tracks[0]:
    if msg.type == "time_signature":
        numerator = int(msg.numerator)
        denominator = int(msg.denominator)
    if "SOF" in str(msg):
        if denominator == 4:
            offset = msg.time
        else:
            offset = 0

if denominator == 8:
    beat = int(beat / 2)
elif denominator == 16:
    beat = int(beat / 4)
elif denominator == 2:
    beat = int(beat * 2)    

if offset == 0:
    offset = beat * numerator

for i, track in enumerate(mid.tracks):
    print('Track {}: {}'.format(i, track.name))
    for msg in track:
        print(msg)
    first_sys = []
    rest_of_sys = []
    for msg in track:
        if msg.type == "sysex":
            if msg.time == 0:
                first_sys.append(msg)
            else:
                rest_of_sys.append(msg)
    if len(first_sys) >= 1:
        first_sys[0].time = offset
        if len(rest_of_sys) >= 1:
            for item in rest_of_sys:
                item.time = item.time - offset

mid.save(path)