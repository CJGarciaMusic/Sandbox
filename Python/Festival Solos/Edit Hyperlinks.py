import xml.etree.ElementTree as ET


def replace_xml_string(path, new_link):
    tree = ET.parse(path)

    root = tree.getroot()

    ET.register_namespace("", "")
    ET.register_namespace("xmlns:xlink", "http://www.w3.org/1999/xlink")
    ET.register_namespace("xlink:show", "new")
    ET.register_namespace("xlink:href", new_link)

    for child in root.iter("link"):
        child.attrib.pop('{http://www.w3.org/1999/xlink}href')
        child.attrib.pop('{http://www.w3.org/1999/xlink}show')
        child.set("xmlns:xlink", "http://www.w3.org/1999/xlink")
        child.set("xlnk:show", "new")
        child.set("xlink:href", new_link)

    tree.write(path)

    tree.write(path, xml_declaration=True)

    with open(path, 'wb') as f:
        f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
        f.write(b'<!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">\n')
        tree.write(f, xml_declaration=False, encoding='utf-8')


hyper_link = "https://asm.smartmusic.com/index.html?bundle=https://library.smartmusic.com/practice/bundles/{0}.json&bundleInstrumentId={0}"

books = {}

for book_number in range(1, 16):
    books["_p{}_".format(str(book_number))] = {}
    for title_num in range(1, 16):
        books["_p{}_".format(str(book_number))][title_num] = {}

counter_one = 0

for first_num in range(1,16):
    for item in range(1,16):
        books["_p{}_".format(str(first_num))][item] = hyper_link.format(30529 + (item-1) + counter_one)
    counter_one = counter_one + 20

for exercise in range(9, 541, 9):
    for part in range(1, 16):
        if exercise <= 36:
            links = books["_p{}_".format(part)][1]
        elif (exercise > 36) and (exercise <= 72):
            links = books["_p{}_".format(part)][2]
        elif (exercise > 72) and (exercise <= 108):
            links = books["_p{}_".format(part)][3]
        elif (exercise > 108) and (exercise <= 144):
            links = books["_p{}_".format(part)][4]
        elif (exercise > 144) and (exercise <= 180):
            links = books["_p{}_".format(part)][5]
        elif (exercise > 180) and (exercise <= 216):
            links = books["_p{}_".format(part)][6]
        elif (exercise > 216) and (exercise <= 252):
            links = books["_p{}_".format(part)][7]
        elif (exercise > 252) and (exercise <= 288):
            links = books["_p{}_".format(part)][8]
        elif (exercise > 288) and (exercise <= 324):
            links = books["_p{}_".format(part)][9]
        elif (exercise > 324) and (exercise <= 360):
            links = books["_p{}_".format(part)][10]
        elif (exercise > 360) and (exercise <= 396):
            links = books["_p{}_".format(part)][11]
        elif (exercise > 396) and (exercise <= 432):
            links = books["_p{}_".format(part)][12]
        elif (exercise > 432) and (exercise <= 468):
            links = books["_p{}_".format(part)][13]
        elif (exercise > 468) and (exercise <= 504):
            links = books["_p{}_".format(part)][14]
        elif (exercise > 504) and (exercise <= 540):
            links = books["_p{}_".format(part)][15]
        path = "/Users/cgarcia/Desktop/410/XML/410_p{}_t{}.musicxml".format(str(part), str(exercise).zfill(3))
        print("This file:", path,"\nWill have this hyperlink:", links, "\n")
        replace_xml_string(path, links)
