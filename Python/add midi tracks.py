from mido import MetaMessage, MidiFile, MidiTrack, Message

sku_num = 410

items_to_add = [9, 17, 18, 11, 20, 26, 27, 29, 35, 36, 38, 44, 45, 47, 53, 54, 56, 62, 63, 65, 71, 72]

def move_to_second_measure(file_path):
    mid = MidiFile(file_path)

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
                if msg.time == 1920:
                    first_sys.append(msg)
                else:
                    rest_of_sys.append(msg)
        if len(first_sys) >= 1:
            first_sys[0].time = offset
            if len(rest_of_sys) >= 1:
                for item in rest_of_sys:
                    item.time = item.time - offset

    mid.save(file_path)


def add_sysex_data(file_path):
    mid = MidiFile(file_path)

    numerator = 0

    for msg in mid.tracks[0]:
        if msg.type == "time_signature":
            numerator = int(msg.numerator)

    for i, track in enumerate(mid.tracks):
        if i > 2:
            print('Track {}: {}'.format(i, track.name))
            # for msg in track:
            # if msg.type == "sysex":
            #     track.append(Message("sysex", data=[58,65,83,61,48], time=2400))
            #     track.append(Message("sysex", data=[58,83,80,61,48], time=0))
            #     track.append(Message("sysex", data=[58,83,80,61,49], time=480))
            # STF=1
            if numerator == 4:
                track.append(Message("sysex", data=[58,83,84,70,61,49], time=1920)) 
            elif numerator == 3:
                track.append(Message("sysex", data=[58,83,84,70,61,49], time=1440)) 
            else:
                print("Something is not right...")


    # track_two = mid.add_track("1/Bells")
    # track_two.append(MetaMessage("text", text="Instrument=None"))
    # track_two.append(MetaMessage("device_name", name="IAC Driver"))

    # track_three = mid.add_track("1/Marimba")
    # track_three.append(MetaMessage("text", text="Instrument=None"))
    # track_three.append(MetaMessage("device_name", name="IAC Driver"))
        
    # track_four = mid.add_track("1/Xylophone")
    # track_four.append(MetaMessage("text", text="Instrument=None"))
    # track_four.append(MetaMessage("device_name", name="IAC Driver"))

    mid.save(file_path)


def delete_tracks(file_path):
    mid = MidiFile(file_path)

    mid.tracks.pop(4)
    mid.tracks.pop(3)
    mid.save(file_path)


for item in items_to_add:
    # path = "/Users/{0}/{0}_build/{0}_t{1}.mid".format(sku_num, str(item).zfill(3))
    path = "/Users/cgarcia/Documents/dpf/410_dev/MID/{0}_t{1}.MID".format(sku_num, str(item).zfill(3))
    # print(path)
    add_sysex_data(path)
