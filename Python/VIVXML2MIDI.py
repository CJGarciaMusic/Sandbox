from mido import MetaMessage, MidiFile, MidiTrack, Message
import xml.etree.ElementTree as ET

path = "/_Converted/23265/qa/resources/2326501.VIVXML"

ET.parse(path)
tree = ET.parse(path)
root = tree.getroot()
mid = MidiFile()
mid_track = MidiTrack()
for child in root.iter("VIV"):
    for item in child:
        if "Tracks" in str(item):
            for track in item:
                if track.attrib.get("TrackName") != None:
                    track_name = track.attrib.get("TrackName")
                    if track_name == "":
                        track_name = "Solo"
                    else:
                        track_name == track.attrib.get("TrackName")
                    print(track_name)
                    # mid.tracks.append(mid_track)
                    mid.add_track(name=track_name)
mid.save("/Users/cgarcia/Desktop/testmidi.mid")
