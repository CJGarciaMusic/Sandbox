from mido import MidiFile, MidiTrack, Message, MetaMessage

for item in range(1, 297):
    sku = "430_t{}".format(str(item).zfill(3))
    path = "/_Source/430/430_build/{}.MID".format(sku)
    mid = MidiFile(path)

    # time = 0

    # for msg in mid.tracks[0]:
    #     if "SOF" in str(msg):
    #         time = msg.time

    for msg in mid.tracks[3]:
        if msg.type == "sysex":
            msg.data = bytearray(b":LY=1")
            # print(bytes.fromhex("F03A4C593D31F7"))
    # for i, track in enumerate(mid.tracks):
    #     if i > 2:
    #         mid.tracks.pop(i)
        # if "Clap" in str(track):
        #     continue
        # else:
    # track_two = mid.add_track("1/Clap")
    # track_two.append(MetaMessage("text", text="Instrument=None"))
    # track_two.append(MetaMessage("device_name", name="IAC Driver"))
    # track_two.append(Message("sysex", data=[58,83,84,70,61,49], time=time)) 

    mid.save(path)

for item in range(1, 297):
    sku = "430_t{}".format(str(item).zfill(3))
    path = "/_Source/430/430_build/{}.MID".format(sku)
    mid = MidiFile(path)
    for i, track in enumerate(mid.tracks):
        if "Clap" in str(track):
            print(item, track)