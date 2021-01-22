from os import listdir
from os.path import isfile, join, isdir

def file_paths(the_path):
    full_list = []
    for filename in listdir(the_path):
        if isfile(join(the_path, filename)):
            if not filename.startswith("."):
                full_list.append(filename.replace(".applescript", ""))

    return sorted(full_list)


mypath = "/Users/cgarcia/CJGit/JetStream/AppleScript/Lua"
path_list = []
for directory in listdir(mypath):
    if isdir(join(mypath, directory)):
        path_list.append(directory)


f = open(mypath + "/Lua Numbers.txt", "w")
f.write("")
f.close()
f = open(mypath + "/Lua Numbers.txt", "a")
for path in sorted(path_list):
    f.write("\n" + path + "\n")
    for file_path in file_paths(join(mypath, path)):
        f.write(file_path + "\n")