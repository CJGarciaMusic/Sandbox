import os

orig_source = os.listdir("/_Source/08010/08010_build")

old_name = open("/Users/cgarcia/Desktop/Old_names.txt", "r")

old_files = old_name.readlines()

new_name = open("/Users/cgarcia/Desktop/New_names.txt", "r")

new_files = new_name.readlines()

line_num = 0

for item in orig_source:
    for f in old_files:
        if item in f:
            file_path = "/_Source/08010/08010_build/{}"
            old_string = old_files[line_num].replace("\n", "")
            new_string = new_files[line_num].replace("\n", "")
            print(file_path.format(old_string), file_path.format(new_string + ".MID"))
            os.rename(file_path.format(old_string), file_path.format(new_string + ".mid"))
            line_num = line_num + 1
