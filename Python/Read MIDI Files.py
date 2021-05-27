from mido import MidiFile, MidiTrack, Message
import os
for item in range(1, 297):
    sku = "S34401{}".format(str(item).zfill(3))
    path = "/_Source/344/344_build/{}.MID".format(sku)
    # path = "/_Source/344/344_build/S34401001.MID"
    if os.path.exists(path):
        mid = MidiFile(path)
        for tn in mid.tracks:
            print(tn)
        # if tn == "track_name":
        #     print(tn)
        # mid.add_track(name="2/Clap")
        # mid.save(path)
        print("==================")