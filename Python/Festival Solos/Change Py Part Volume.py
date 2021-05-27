import xml.etree.ElementTree as ET


def bottom_to_zero(path):

    try:
        ET.parse(path)
        tree = ET.parse(path)
        root = tree.getroot()

        ET.register_namespace("", "")

        for child in root.iter("midi-instrument"):
            if "P2" in str(child.attrib):
                for item in child:
                    if item.tag == "volume":
                        new_vol = 0
                        item.text = str(new_vol)
                        item.set("updated", "yes")

        tree.write(path)
        tree.write(path, xml_declaration=True)

        with open(path, 'wb') as f:
            f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
            f.write(b'<!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">\n')
            tree.write(f, xml_declaration=False, encoding='utf-8')
    except:
        print("No file", path)


def top_to_zero(path):
    try:
        ET.parse(path)
        tree = ET.parse(path)
        root = tree.getroot()

        ET.register_namespace("", "")

        for child in root.iter("midi-instrument"):
            if "P1" in str(child.attrib):
                for item in child:
                    if item.tag == "volume":
                        new_vol = 0
                        item.text = str(new_vol)
                        item.set("updated", "yes")

        tree.write(path)
        tree.write(path, xml_declaration=True)

        with open(path, 'wb') as f:
            f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
            f.write(b'<!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">\n')
            tree.write(f, xml_declaration=False, encoding='utf-8')
    except:
        print("No file", path)

for exercise in range(4, 541, 9):
    for part in range(1, 10):
        path = "/Users/cgarcia/Desktop/410/XML/410_p{}_t{}.musicxml".format(str(part), str(exercise).zfill(3))
        bottom_to_zero(path)
    for part in range(11, 16):
        path = "/Users/cgarcia/Desktop/410/XML/410_p{}_t{}.musicxml".format(str(part), str(exercise).zfill(3))
        bottom_to_zero(path)

for exercise in range(5, 541, 9):
    path = "/Users/cgarcia/Desktop/410/XML/410_p10_t{}.musicxml".format(str(exercise).zfill(3))
    bottom_to_zero(path)

for exercise in range(6, 541, 9):
    for part in range(1, 10):
        path = "/Users/cgarcia/Desktop/410/XML/410_p{}_t{}.musicxml".format(str(part), str(exercise).zfill(3))
        top_to_zero(path)
    for part in range(11, 16):
        path = "/Users/cgarcia/Desktop/410/XML/410_p{}_t{}.musicxml".format(str(part), str(exercise).zfill(3))
        top_to_zero(path)
    
for exercise in range(7, 541, 9):
    path = "/Users/cgarcia/Desktop/410/XML/410_p10_t{}.musicxml".format(str(exercise).zfill(3))
    top_to_zero(path)