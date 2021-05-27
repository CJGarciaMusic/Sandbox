from mido import MidiFile, MidiTrack, Message

for item in range(10, 37, 9):
    sku = "420_t{}".format(str(item).zfill(3))
    path = "/_Source/420/420_build/{}.MID".format(sku)
    # print(path)
    mid = MidiFile(path)
    mid.add_track(name="2/Clap")
    mid.save(path)
    