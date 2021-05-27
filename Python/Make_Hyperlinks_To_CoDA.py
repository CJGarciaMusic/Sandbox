import gspread
from oauth2client.service_account import ServiceAccountCredentials

scope = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]
cred_path = "/Users/cgarcia/Google Drive/RepDev Python Scripts//MethodBookNames.json"
creds = ServiceAccountCredentials.from_json_keyfile_name(cred_path, scope)
client = gspread.authorize(creds)

# 6 = June 2019
# 14 = Test Dev List

release_plan_sheet = client.open("Release Plan 2019").get_worksheet(14)

accountability_sheet = client.open("RepDev Progress Chart").get_worksheet(0)

release_sku_col = release_plan_sheet.col_values(1)

def assign_coda_links(source_range, dest_range):
    for item in range(dest_range[0], dest_range[1]):
        sku_col_as_string = str(release_sku_col[item])
        if sku_col_as_string.isdigit():
            sku_coor = release_plan_sheet.find(sku_col_as_string)
            search_first_col = accountability_sheet.range(source_range)
            result_cell = [found for found in search_first_col if found.value == sku_col_as_string]
            long_sku = str(result_cell)[7:]
            medium_sku = long_sku.replace(sku_col_as_string, "")[1:-7]
            if medium_sku != "":
                product_num = accountability_sheet.cell(row=medium_sku, col=2).value
                new_value = '=HYPERLINK("http://content.smartmusic.com/#/collection/{}","{}")'.format(product_num, sku_col_as_string)
                release_plan_sheet.update_cell(row=sku_coor.row, col=sku_coor.col, value=new_value)
            else:
                continue
        else:
            continue

# insert your row range here so Google doesn't think you're spam when trying to do the entire sheet
source_working_rows = "A1:A46"
destination_working_rows = [167, 251]

assign_coda_links(source_working_rows, destination_working_rows)