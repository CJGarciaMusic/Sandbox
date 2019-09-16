from mido import MidiFile, MidiTrack, MetaMessage
import re
import os

sku_num = 446
progress = 0
total = 927

def matching_midi_to_audio(midi_file_path):
    mid = MidiFile(midi_file_path)
    stripped_file_name = re.search(r"t(.*)\.", midi_file_path)
    for track in mid.tracks:
        if "Accomp" in str(track):
            for msg in track:
                if msg.type == "text":
                    accomp_text = "Instrument=Arrangement,T,NewPiano"
                    if msg.text != accomp_text:
                        print(stripped_file_name)
        elif "Solo" in str(track):
            for msg in track:
                if msg.type == "text":
                    solo_text = "Instrument=Solo,T"
                    if msg.text != solo_text:
                        print(stripped_file_name)
                    
for item in range(1, (total + 1)):
    midi_path = r"/_Source/{0}/{0}_build/{0}_t{1}.MID".format(sku_num, str(item).zfill(3))
    stripped_file_path = re.search(r"t(.*)\.", midi_path)
    try:
        matching_midi_to_audio(midi_path)
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