import gspread
import os
import glob
import shutil
from oauth2client.service_account import ServiceAccountCredentials

scope = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]
cred_path = "/Users/cgarcia/Google Drive/RepDev Python Scripts/MethodBookNames.json"
creds = ServiceAccountCredentials.from_json_keyfile_name(cred_path, scope)
client = gspread.authorize(creds)

src = glob.glob("/Users/cgarcia/Google Drive/sheets/*.gsheet")

real_path = ""

for item in src:
    if "QA" in item:
        real_path = item

new_source = os.path.abspath(real_path)

release_plan_sheet = client.open("Release Plan 2018").get_worksheet(29)

print(release_plan_sheet)