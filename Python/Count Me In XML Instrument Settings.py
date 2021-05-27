import xml.etree.ElementTree as ET


def change_instrument(path):
    # try:
        ET.parse(path)
        tree = ET.parse(path)
        root = tree.getroot()

        ET.register_namespace("", "")

        for child in root.iter("midi-instrument"):
            for item in child:
                if item.tag == "volume":
                    new_vol = 80
                    item.text = str(new_vol)
                    item.set("updated", "yes")
                if item.tag == "midi-unpitched":
                    new_pitch = 40
                    item.text = str(new_pitch)
                    item.set("updated", "yes")
                if item.tag == "midi-program":
                    new_program = 1
                    item.text = str(new_program)
                    item.set("updated", "yes")
                if item.tag == "midi-bank":
                    new_bank = 15489
                    item.text = str(new_bank)
                    item.set("updated", "yes")
                if item.tag == "midi-channel":
                    new_channel = 1
                    item.text = str(new_channel)
                    item.set("updated", "yes")
                if item.tag == "pan":
                    new_pan = 0
                    item.text = str(new_pan)
                    item.set("updated", "yes")

        tree.write(path)
        tree.write(path, xml_declaration=True)

        with open(path, 'wb') as f:
            f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
            f.write(b'<!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">\n')
            tree.write(f, xml_declaration=False, encoding='utf-8')
    # except:
    #     print("No file", path)


for part in range(1, 297):
    path = "/Users/cgarcia/Documents/430/430_p1_t{}.musicxml".format(str(part).zfill(3))
    change_instrument(path)
