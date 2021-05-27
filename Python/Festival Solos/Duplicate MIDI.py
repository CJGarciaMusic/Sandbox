from mido import MetaMessage, MidiFile, MidiTrack, Message

sku_num = 410

def add_sysex_data(file_path, audio_file):
    mid = MidiFile(file_path)

    for i, track in enumerate(mid.tracks):
        print('Track {}: {}'.format(i, track.name))
        for msg in track:
            if "AudFile" in str(msg):
                print(msg)
                track.append(MetaMessage("text", text="Instrument=Accomp,T,AudioPianoSolo\\Tune=440\\AudFile={}\\AudOffsetMS=0".format(audio_file)))

    mid.save(file_path)


for item in range(3, 4):
    path = "/Users/cgarcia/Documents/dpf/410_dev/MID/{0}-t{1}.MID".format(sku_num, str(item).zfill(3))
    add_sysex_data(path, "{}-{}".format(sku_num, str(item).zfill(3)))