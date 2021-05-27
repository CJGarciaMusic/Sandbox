import xml.etree.ElementTree as ET
from zipfile import ZipFile 
import os 
import sys


def change_instrument(path):
    try:
        ET.parse(path)
        tree = ET.parse(path)
        root = tree.getroot()

        ET.register_namespace("", "")
        page_height = 0
        top_margin = 0
        line_break_in_inst_name = ""
        has_line_break = False
        for child in root.iter("page-layout"):
            for item in child:
                if item.tag == "page-height":
                    page_height = item.text
                if item.tag == "top-margin":
                    top_margin = item.text


        for child in root.iter("defaults"):
            for item in child:
                if item.tag == "music-font":
                    item.set("font-family", "Maestro")
        
        for child in root.iter("score-part"):
            for item in child:
                if (item.tag == "part-name") or (item.tag == "part-abbreviation"):
                    item.set("print-object", "no")
                    item.set("updated", "yes")
                if item.tag == "part-name-display":
                    if (len(item.getchildren())) == 2:
                        has_line_break = True
                        line_break_in_inst_name = item[0].text + " \n" + item[1].text
                        item[0].text = item[0].text + " " + item[1].text
                        for remove_item in item:
                            if remove_item.text == item[1].text:
                                item.remove(remove_item)
        
        for child in root.iter("credit"):
            for item in child:
                if item.tag == "credit-words":
                    if item.attrib["justify"] == "center":
                        title_text = (int(page_height) - int(top_margin)) - 90
                        item.set("default-y", str(title_text))
                    if item.attrib["justify"] == "right":
                        composer_text = (int(page_height) - int(top_margin)) - 180
                        item.set("default-y", str(composer_text))
                    if item.attrib["justify"] == "left":
                        if has_line_break == True:
                            item.text = line_break_in_inst_name
                        instrument_text = (int(page_height) - int(top_margin)) - 144
                        item.set("default-y", str(instrument_text))

        # for part in root.iter("part"):
        #     for child in part:
        #         for item in child:
        #             for note in item:
        #                 if note.text == "slash":
        #                     note.text = "diamond"   
        #                    

        # for part in root.iter("part"):
        #         for child in part:
        #             for item in child:
        #                 if item.tag == "direction":
        #                     for direction in item:
        #                         for text_item in direction:
        #                             if text_item.text == "p - f":
        #                                 text_item.attrib["font-family"] = "Maestro"
        #                                 text_item.attrib["font-size"] = "20"
        #                                 text_item.attrib["default-y"] = "-50"

        for child in root.iter("direction"):
            for item in child:
                if item.tag == "direction-type":
                    for next_item in item:
                        if next_item.tag == "metronome":
                            item.remove(next_item)
                        elif next_item.text == "`":
                            item.remove(next_item)

        tree.write(path)
        tree.write(path, xml_declaration=True)

        with open(path, 'wb') as f:
            f.write(b'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n')
            f.write(b'<!DOCTYPE score-partwise PUBLIC "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">\n')
            tree.write(f, xml_declaration=False, encoding='utf-8')


    except:
        print("No file", path)


file_path_list = []

def extract_files(single_file, output_path, path_table):
    with ZipFile(single_file, 'r') as zip:
        zip.extractall(output_path)
        for name in zip.namelist():
            path_table.append(output_path+name)
        
def remove_files(file_list, original_mxl):
    for item in file_list:
        if (os.path.isfile(item)) and ("container" not in item):
            change_instrument(item)
        if os.path.isdir(item):
            for filename in os.listdir(item):
                ind_file_path = os.path.join(item, filename)
                os.remove(ind_file_path)
            os.rmdir(item)

    # os.remove(original_mxl)


for file in os.listdir(sys.argv[1]):
    if file.endswith(".mxl"):
        print(file)
        extract_files(os.path.join(sys.argv[1], file), sys.argv[1]+"/", file_path_list)
        remove_files(file_path_list, os.path.join(sys.argv[1], file))