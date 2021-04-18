# full_list = []

# for num in range(217, 541):
#     full_list.append(num)

# non_accomp_list = []

# for item in range(0, 324, 9):
#     non_accomp_list.append("410_t"+str(full_list[item + 0]))
#     non_accomp_list.append("410_t"+str(full_list[item + 1]))
#     non_accomp_list.append("410_t"+str(full_list[item + 7]))
#     non_accomp_list.append("410_t"+str(full_list[item + 8]))


# smcfg = open("/_Destination/410/qa/410.SMCFG", "r")
# new_smcfg = open("/Users/cgarcia/Desktop/410_new.SMCFG", "w")

# for line in smcfg.readlines():
#     for accomp in non_accomp_list:
#         if accomp in line:
#             new_smcfg.write("A="+accomp+"\\\\0\\0")
#         else:
#             new_smcfg.write(line)
# smcfg.close
# new_smcfg.close

def get_bundles(inst_num):
    bundle_nums = []
    orig_num = 553665 + inst_num
    bundle_nums.append(orig_num)

    for num in range(0, 14):
        if num < 4:
            new_bundle = 554086 + (num * 420) + inst_num
            bundle_nums.append(new_bundle)
        if num == 4:
            new_bundle = 554086 + (num * 420) + 1 + inst_num
            bundle_nums.append(new_bundle)
        if num == 5:
            new_bundle = 554086 + (num * 420) + 2 + inst_num
            bundle_nums.append(new_bundle)
        if num > 5:
            new_bundle = 554086 + (num * 420) + 3 + inst_num
            bundle_nums.append(new_bundle)
    
    inst_nums = []
    orig_num = 779153 + inst_num
    inst_nums.append(orig_num)

    for num in range(0, 14):
        if num < 4:
            new_ins_id = 779590 + (num * 420) + inst_num
            inst_nums.append(new_ins_id)
        if num == 4:
            new_ins_id = 779590 + (num * 420) + 5 + inst_num
            inst_nums.append(new_ins_id)
        if num == 5:
            new_ins_id = 779590 + (num * 420) + 6 + inst_num
            inst_nums.append(new_ins_id)
        if num > 5:
            new_ins_id = 779590 + (num * 420) + 21 + inst_num
            inst_nums.append(new_ins_id)

    final_sku = []

    for item in range(0, 15):
        final_sku.append("https://asm.smartmusic.com/index.html?bundle=https://library.smartmusic.com/practice/bundles/{}.json&bundleInstrumentId={}".format(bundle_nums[item], inst_nums[item]))
        # print("https://asm.smartmusic.com/index.html?bundle=https://library.smartmusic.com/practice/bundles/{}.json&bundleInstrumentId={}".format(bundle_nums[item], inst_nums[item]))
    # return bundle_nums, inst_nums
    return final_sku

for item in range(0,15):
    print("Instrument", str(item + 1)+": ")
    print(get_bundles(item))

