from mido import MidiFile, MidiTrack, MetaMessage

path = "/_Source/10427/10427_build/1042701.mid"

# path = "/_Source/10427/10427_build/newmidi.mid"

mid = MidiFile(path)
track = MidiTrack
for msg in mid.tracks[0]:
    if msg.type == "set_tempo":
        mid.tracks[2].append(MetaMessage("set_tempo", tempo=msg.tempo, time=msg.time))
    if msg.type == "time_signature":
        if msg.denominator > 100:
            msg.denominator = 8
        mid.tracks[2].append(MetaMessage("time_signature", numerator=msg.numerator, denominator=msg.denominator, time=msg.time,))

mid.tracks.pop(0)

mid.save("/_Source/10427/10427_build/newmidi.mid")