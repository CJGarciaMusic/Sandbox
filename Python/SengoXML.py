import xml.etree.ElementTree as ET
import os

def change_instrument(path):
        ET.parse(path)
        tree = ET.parse(path)
        root = tree.getroot()

        ET.register_namespace("", "")

        # replace existing
        for child in root.iter("direction"):
            for item in child:
                if item.tag == "direction-type":
                    for word in item.iter("words"):
                        if word.text == "To Coda ":
                            new_text = "To Coda ı"
                            word.text = (new_text)
                        if word.text == "D.S. ":
                            new_text = "D.S. ˆ"
                            word.text = (new_text)
                        if word.text == " Coda ":
                            new_text = "ı Coda"
                            word.text = (new_text)
        
        # create new
        for child in root.iter("measure"):
            if child.attrib["text"] == "10":
                c = ET.Element("direction")
                c.set("placement", "above")
                child.insert(2, c)

                d = ET.Element("direction-type")
                c.insert(1, d)

                e = ET.Element("words")
                e.set("default-x", "0")
                e.set("default-y", "0")
                e.set("font-size", "24")
                e.set("halign", "left")
                e.text = "ˆ"

                d.insert(1, e)

        tree.write(path)
        tree.write(path, xml_declaration=True)

        with open(path, 'wb') as f:
            f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
            f.write(b'<!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">\n')
            tree.write(f, xml_declaration=False, encoding='utf-8')


for file in os.listdir("/Users/cgarcia/Desktop/Add Sengo/"):
    if file.endswith(".musicxml"):
        path = (os.path.join("/Users/cgarcia/Desktop/Add Sengo/", file))
        change_instrument(path)
# change_instrument("/Users/cgarcia/Downloads/27387_19D-1.musicxml")