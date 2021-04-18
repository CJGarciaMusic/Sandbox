import xml.etree.ElementTree as ET


fnfFilePath = "387_t001.fnf"

# def RemoveNamespaceFromFnf(self, fnfFilePath):
with open(fnfFilePath, 'r') as fnfRead:
    lines = fnfRead.readlines()

if len(lines) < 2:
    raise Exception('Fnf file is empty')
else:
    if '<finale ' in lines[1]:
        namespaceLine = lines[1]
        del lines[1]
        lines.insert(1, '<finale>\n')

        with open(fnfFilePath, 'w') as fnfWrite:
            newContents = "".join(lines)
            fnfWrite.write(newContents)
            del lines[:]
    else:
        raise Exception('Did not find namespace in file')

tree = ET.parse("387_t001.fnf")

root = tree.getroot()

old_page_height = root[2][21][1][0]

new_page_height = str(3456)

root[2][21][1][0].text = new_page_height

print(old_page_height.text)

tree.write("387_t001_new.fnf")


# def ReAddNamespaceToFnf(self, fnfFilePath):
with open(fnfFilePath, 'r') as fnfRead:
    lines = fnfRead.readlines()

if len(lines) < 2:
    raise Exception('File is empty')
else:
    if '<finale>' in lines[1]:
        del lines[1]
        lines.insert(1, namespaceLine)

        with open(fnfFilePath, 'w') as fnfWrite:
            newContents = "".join(lines)
            fnfWrite.write(newContents)
            del lines[:]
    else:
        raise Exception('Was not able to re add the namespace line')


