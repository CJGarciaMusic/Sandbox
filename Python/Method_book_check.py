from mido import MidiFile, MidiTrack, MetaMessage
import re
import os

sku_num = 446
progress = 0
total = 408

def matching_midi_to_audio(midi_file_path, audio_file_path):
    mid = MidiFile(midi_file_path)
    stripped_file_name = re.search(r"t(.*)\.", midi_file_path)
    for track in mid.tracks:
        if "Accomp" in str(track):
            for msg in track:
                if msg.type == "text":
                    accomp_text = str(msg.text)
                    stripped_accomp_text = re.search("AudFile="+str(sku_num)+"-(.*)\\\\AudOffset", accomp_text)
                    if (stripped_file_name.group(1) == stripped_accomp_text.group(1)):
                        continue
                    else:
                        print("Error: Audio in accomp text does not match the file name --- File:", stripped_file_name.group(1))
            if os.path.exists(audio_file_path):
                continue
            else:
                 print("Error: A MIDI file exists for this exercise, but an MP3 file does not --- File:", stripped_file_name.group(1))
    if "Accomp" not in str(mid.tracks):
        if os.path.exists(audio_file_path):
            print("Error: Something went horribly wrong. There's no accomp track, yet you have an MP3 for this file... check yo self. --- File:", stripped_file_name.group(1))     
        else:
            print("Warning: No audio accompaniment detected. Double check that this is a MIDI only accomp --- File:", stripped_file_name.group(1))


for item in range(1, (total + 1)):
    midi_path = r"/Users/cgarcia/Google Drive/dev/{0}/DP/{0}_t{1}.MID".format(sku_num, str(item).zfill(3))
    aud_path = r"/Users/cgarcia/Google Drive/dev/{0}/DP/{0}-{1}.mp3".format(sku_num, str(item).zfill(3))
    stripped_file_path = re.search(r"t(.*)\.", midi_path)
    try:
        matching_midi_to_audio(midi_path, aud_path)
        progress = progress + 1
    except FileNotFoundError:
        print("Error: MIDI file was not found --- File:", stripped_file_path.group(1))
    except AttributeError:
        continue 
            # print("Warning: Attribute error. --- File:", stripped_file_path.group(1))
        # print("Error: It is likely an MP3 file was not found --- File:", stripped_file_path.group(1))

if progress < total:
    print("Keep going, you only have {} more to go!\n".format(total - progress), progress, "/", total)
else:
    print("Woohoo! You're all done!", progress, "/", total)