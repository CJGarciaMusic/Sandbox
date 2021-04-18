import gspread
from oauth2client.service_account import ServiceAccountCredentials
import os

scope = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]
cred_path = "/Users/cgarcia/Google Drive/RepDev Python Scripts//MethodBookNames.json"
creds = ServiceAccountCredentials.from_json_keyfile_name(cred_path, scope)
client = gspread.authorize(creds)

sheet = client.open("410 - Festival Solos Lesson Plan").sheet1

sku_num = "410"

def rename(number_of_instruments):
    for instrument in range(1, (int(number_of_instruments) + 1)):
    #   uncomment out the next line if you need to start from instrument 13 and go to instrument 15
    # for instrument in range(13, 16):
        title_names_to_use = []
        root = "/Users/cgarcia/Desktop/{}/{}".format(sku_num, str(instrument).zfill(2))
        # This is the column with the first instrument file name
        result = sheet.col_values(instrument + 1)
        index = 0
        for item in result:
            if sku_num in item:
                title_names_to_use.append(item)
            else:
                pass

        for file in sorted(os.listdir(root)):
            if "DS" in file:
                pass
            else:
                full_path = "/Users/cgarcia/Desktop/{}/{}/{}".format(sku_num, str(instrument).zfill(2), file)
                new_full_path = "/Users/cgarcia/Desktop/{}/{}/{}{}".format(sku_num, str(instrument).zfill(2), title_names_to_use[index], ".MUSX")
                os.renames(full_path, new_full_path)
                print(full_path, new_full_path)
                index = index + 1


desktop_folder = "/Users/cgarcia/Desktop/{}".format(sku_num)

item_list = 0

for folder in sorted(os.listdir(desktop_folder)):
    if "DS" in folder:
        pass
    else:
        print(folder)
        item_list = item_list + 1

rename(item_list)
