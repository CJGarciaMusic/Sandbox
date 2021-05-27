import os

sku_num = "410"

path = "/Users/cgarcia/Desktop/{}/".format(sku_num)


def rename_instruments(file_path):
    for root, dirs, file in os.walk(file_path):
        print(dirs)
        for files in file:
            # change this number when you do another round of files, you'll remember... I hope
            count = 433
            if "1-1" in files:
                count = count + 0
            elif "1-2" in files:
                count = count + 1
            elif "1-3a" in files:
                count = count + 2
            elif "1-3b" in files:
                count = count + 3
            elif "1-3c" in files:
                count = count + 4
            elif "1-4" in files:
                count = count + 5
            elif "1-5" in files:
                count = count + 6
            elif "2-1" in files:
                count = count + 7
            elif "2-2" in files:
                count = count + 8
            elif "2-3a" in files:
                count = count + 9
            elif "2-3b" in files:
                count = count + 10
            elif "2-3c" in files:
                count = count + 11
            elif "2-4" in files:
                count = count + 12
            elif "2-5" in files:
                count = count + 13
            elif "3-1" in files:
                count = count + 14
            elif "3-2" in files:
                count = count + 15
            elif "3-3a" in files:
                count = count + 16
            elif "3-3b" in files:
                count = count + 17
            elif "3-3c" in files:
                count = count + 18
            elif "3-4" in files:
                count = count + 19
            elif "3-5" in files:
                count = count + 20
            elif "4-1" in files:
                count = count + 21
            elif "4-2" in files:
                count = count + 22
            elif "4-3a" in files:
                count = count + 23
            elif "4-3b" in files:
                count = count + 24
            elif "4-3c" in files:
                count = count + 25
            elif "4-4" in files:
                count = count + 26
            elif "4-5" in files:
                count = count + 27

            if "Flute" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p1_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Oboe" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p2_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Bassoon" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p3_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Clarinet in" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p4_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Bass Clarinet" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p5_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Alto Sax" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p6_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Tenor Sax" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p7_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Baritone Sax" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p8_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Trumpet" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p9_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Horn in" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p10_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Baritone (T" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p11_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Baritone (B" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p12_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Trombone" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p13_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Tuba" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p14_u".format(sku_num)+str(count).zfill(3)+".musx"))
            elif "Mallet" in files:
                os.rename(os.path.join(root, files), os.path.join(root, "{}_p15_u".format(sku_num)+str(count).zfill(3)+".musx"))


def move_musx(path):
    for root, dirs, file in os.walk(path):
        print(dirs)
        for files in file:
            if "_p1_" in files:
                os.rename(os.path.join(root, files), path+"01/"+files)
            elif "_p2_" in files:
                os.rename(os.path.join(root, files), path+"02/"+files)
            elif "_p3_" in files:
                os.rename(os.path.join(root, files), path+"03/"+files)
            elif "_p4_" in files:
                os.rename(os.path.join(root, files), path+"04/"+files)
            elif "_p5_" in files:
                os.rename(os.path.join(root, files), path+"05/"+files)
            elif "_p6_" in files:
                os.rename(os.path.join(root, files), path+"06/"+files)
            elif "_p7_" in files:
                os.rename(os.path.join(root, files), path+"07/"+files)
            elif "_p8_" in files:
                os.rename(os.path.join(root, files), path+"08/"+files)
            elif "_p9_" in files:
                os.rename(os.path.join(root, files), path+"09/"+files)
            elif "_p10_" in files:
                os.rename(os.path.join(root, files), path+"10/"+files)
            elif "_p11_" in files:
                os.rename(os.path.join(root, files), path+"11/"+files)
            elif "_p12_" in files:
                os.rename(os.path.join(root, files), path+"12/"+files)
            elif "_p13_" in files:
                os.rename(os.path.join(root, files), path+"13/"+files)
            elif "_p14_" in files:
                os.rename(os.path.join(root, files), path+"14/"+files)
            elif "_p15_" in files:
                os.rename(os.path.join(root, files), path+"15/"+files)


rename_instruments(path)

move_musx(path)