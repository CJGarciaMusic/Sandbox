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

# 6 = June 2019
# 14 = Test Dev List

release_plan_sheet = client.open("Release Plan 2019").get_worksheet(14)

release_sku_col = release_plan_sheet.col_values(1)
release_name_col = release_plan_sheet.col_values(2)


def make_qa_sheet(row_range):
    """
    will create QA sheets if they don't already exists. Uses the naming scheme of SKU - TITLE
    """
    for item in range(row_range[0], row_range[1]):
        sku_col_as_string = str(release_sku_col[item])
        sku_name_as_string = str(release_name_col[item])
        if sku_col_as_string.isdigit():
            if "\"" in sku_name_as_string:
                sku_name_as_string = sku_name_as_string.replace("\"", "'")
            if "/" in sku_name_as_string:
                sku_name_as_string = sku_name_as_string.replace("/", "_")
            qa_sheet_title = sku_col_as_string + ' - ' + sku_name_as_string
            try:
                client.open(qa_sheet_title).id
            except gspread.SpreadsheetNotFound:
                dst = "/Users/cgarcia/Google Drive/RepDev QA Sheets/{}.gsheet".format(qa_sheet_title)
                shutil.copy2(new_source, os.path.abspath(dst))
        else:
            continue


def apply_qa_sheet(row_range):
    """
    will find and apply QA sheets
    """
    for item in range(row_range[0], row_range[1]):
        sku_col_as_string = str(release_sku_col[item])
        sku_name_as_string = str(release_name_col[item])
        if sku_col_as_string.isdigit():
            if "\"" in sku_name_as_string:
                sku_name_as_string = sku_name_as_string.replace("\"", "'")
            if "/" in sku_name_as_string:
                sku_name_as_string = sku_name_as_string.replace("/", "_")
            qa_sheet_title = sku_col_as_string + ' - ' + sku_name_as_string
            qa_sheet_link = client.open(qa_sheet_title).id
            sku_coor = release_plan_sheet.find(sku_col_as_string)
            new_value = '=HYPERLINK("docs.google.com/spreadsheets/d/{}","{}")'.format(qa_sheet_link, sku_name_as_string)
            release_plan_sheet.update_cell(row=sku_coor.row, col=sku_coor.col + 1, value=new_value)

# insert your row range here so Google doesn't think you're spam when trying to do the entire sheet
working_rows = [167, 251]

make_qa_sheet(working_rows)
apply_qa_sheet(working_rows)