smspec = open("/_Destination/410/qa/410.SMSPEC", "r")
new_spec = open("/Users/cgarcia/Desktop/410_new.SMPEC", "w")

for line in smspec.readlines():
    if "MP3" in line:
        continue
    else:
        new_spec.write(line)

smspec.close
new_spec.close