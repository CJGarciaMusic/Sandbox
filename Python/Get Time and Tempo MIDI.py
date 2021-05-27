import mido
from mido import MidiFile, tempo2bpm
import os
def move_to_second_measure(file_path):
    mid = MidiFile(file_path)

    time_sig = ""
    tempo = 0

    # conductor track
    for msg in mid.tracks[0]:
        if msg.type == "time_signature":
            time_sig = str(msg.numerator)+"/"+str(msg.denominator)
        if "tempo" in msg.type:
            tempo = tempo2bpm(int(msg.tempo))

    print(time_sig, round(tempo))

path = "/Users/cgarcia/Desktop/Hanon MID"
midi_file = []


for item in os.walk("/Users/cgarcia/Desktop/Hanon MID"):
    for file in item:
        if ".MID" in str(file):
            mid_file = file
            for mid in mid_file:
                midi_file.append(mid)

for midi in sorted(midi_file):
    print(midi)
    move_to_second_measure("/Users/cgarcia/Desktop/Hanon MID/" + midi)
                