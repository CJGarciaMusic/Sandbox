import os 
import sys
import shutil

def create_instrument(original_file_path, original_file_name, inst_name, old_ending):
        old_path = os.path.join(original_file_path, file)
        add_inst_name = ""

        add_inst_name = str(original_file_name).replace("08012", inst_name)

        remove_old_ending = add_inst_name.replace(old_ending, ".musx")

        new_file_name = ""
        if remove_old_ending.find("_0A") != -1:
            new_file_name = remove_old_ending.replace("_0A", "_10")
        elif remove_old_ending.find("_0B") != -1:
            new_file_name = remove_old_ending.replace("_0B", "_11")
        elif remove_old_ending.find("_0C") != -1:
            new_file_name = remove_old_ending.replace("_0C", "_12")
        elif remove_old_ending.find("_0D") != -1:
            new_file_name = remove_old_ending.replace("_0D", "_13")
        elif remove_old_ending.find("_0E") != -1:
            new_file_name = remove_old_ending.replace("_0E", "_14")
        elif remove_old_ending.find("_0F") != -1:
            new_file_name = remove_old_ending.replace("_0F", "_15")
        else:
            new_file_name = remove_old_ending

        new_path = os.path.join(original_file_path, new_file_name)
        shutil.copy(old_path, new_path)
        

for file in os.listdir(sys.argv[1]):
    if file.endswith("A.musx") and file.startswith("08012"):
        # create_instrument(sys.argv[1], file, "28351_01F_0", "A.musx")
        # create_instrument(sys.argv[1], file, "28351_04B_0", "A.musx")
    #     create_instrument(sys.argv[1], file, "28351_02O_0", "A.musx")
    #     create_instrument(sys.argv[1], file, "28351_12TN_0", "A.musx")
    #     create_instrument(sys.argv[1], file, "28351_13BBC_0", "A.musx")
    #     create_instrument(sys.argv[1], file, "28351_16TB_0", "A.musx")
    #     create_instrument(sys.argv[1], file, "28351_21EB_0", "A.musx")
    # if file.endswith("B.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_19PPC_0", "B.musx")
    # if file.endswith("C.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_22ETB_0", "C.musx")
    # if file.endswith("D.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_03C_0", "D.musx")
    #     create_instrument(sys.argv[1], file, "28351_06BC_0", "D.musx")
    #     create_instrument(sys.argv[1], file, "28351_08TX_0", "D.musx")
    #     create_instrument(sys.argv[1], file, "28351_10T_0", "D.musx")
    #     create_instrument(sys.argv[1], file, "28351_14BTC_0", "D.musx")
    #     create_instrument(sys.argv[1], file, "28351_23TNT_0", "D.musx")
    #     create_instrument(sys.argv[1], file, "28351_24BTBTC_0", "D.musx")
    # if file.endswith("E.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_05AC_0", "E.musx")
    #     create_instrument(sys.argv[1], file, "28351_07AX_0", "E.musx")
    #     create_instrument(sys.argv[1], file, "28351_09BX_0", "E.musx")
    # if file.endswith("F.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_11H_0", "F.musx")
    # if file.endswith("G.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_15EH_0", "G.musx")
    # if file.endswith("X.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_17NPC_0", "X.musx")
    # if file.endswith("Y.musx") and file.startswith("08012"):
    #     create_instrument(sys.argv[1], file, "28351_20TMP_0", "Y.musx")

# run in terminal with this
# /usr/local/bin/python3 /Users/cgarcia/CJGit/Work/Python/SoE_namechange.py /Users/cgarcia/Downloads/08012/08012_mus