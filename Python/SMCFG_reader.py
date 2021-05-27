smcfg_file = "/Users/cgarcia/Desktop/410.SMCFG"
open_file = open(smcfg_file, "r")
end_result = "/Users/cgarcia/Desktop/410.txt"
write_file = open(end_result, "w")

song_title = []
midi_file = []

index = 1
for line in open_file:
    if line.find("A=") != -1:
        break_point = line.find("\\")
        song_title.append(line[2:break_point])
        # song_title.append(str(index).zfill(5)+". "+line)
    # if line.find("M=") != -1:
    #     midi_file.append(str(index).zfill(5)+". "+line)
    if line.find("M=") != -1:
        break_point = line.find("\\")
        midi_file.append(line[2:break_point])
        # midi_file.append(str(index).zfill(5)+". "+line)
    # else: 
    #     pass
    index = index + 1
open_file.close()

full_list = zip(song_title, midi_file)

count = 1

for item in sorted(full_list):
    if str(item[0][4:]) not in str(item[1]):
        print("This title is not assigned correctly", item[0], "->", item[1])
        print("=========================> Should be remapped as", item[1][:-3]+item[0][5:])
        print("")
        count = count + 1

print("Total of ", count, "titles need to be fixed")

# list_2 = []
# i = {}
# for k, s in sorted(full_list):
#     if k[7:] not in i:
#         list_2.append((k[7:], s))
#         i[k] = len(i)
#     else:
#         list_2[i[k]][1].extend(s)

# for item in list_2:
#     print(item, "\n", "\n")


# for item in sorted(full_list):
#     write_file.write(str(item))
#     write_file.write("\n")

# write_file.close()

