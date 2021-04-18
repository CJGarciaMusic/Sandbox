import gspread
from oauth2client.service_account import ServiceAccountCredentials

scope = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]
cred_path = "/Users/cgarcia/Google Drive/RepDev Python Scripts/MethodBookNames.json"
creds = ServiceAccountCredentials.from_json_keyfile_name(cred_path, scope)
client = gspread.authorize(creds)

release_plan_sheet = client.open("Release Plan 2018").get_worksheet(24)
accountability_sheet = client.open("RepDev Progress Chart").get_worksheet(2)

release_sku_col = release_plan_sheet.col_values(1)
release_name_col = release_plan_sheet.col_values(2)
ensemble_col = release_plan_sheet.col_values(3)

method_counter = 0
band_counter = 0
choral_counter = 0
string_counter = 0
jazz_counter = 0
solo_counter = 0
full_orch_counter = 0

for ens in ensemble_col:
    if ens == "Method":
        method_counter = method_counter + 1
    if ens == "Concert Band":
        band_counter = band_counter + 1
    if ens == "Choir":
        choral_counter = choral_counter + 1
    if ens == "String Orchestra":
        string_counter = string_counter + 1
    if ens == "Jazz Ensemble":
        jazz_counter = jazz_counter + 1
    if ens == "Solo":
        solo_counter = solo_counter + 1
    if ens == "Full Orchestra":
        full_orch_counter = full_orch_counter + 1

accountability_sheet.update_acell("B97", method_counter)
accountability_sheet.update_acell("B98", band_counter)
accountability_sheet.update_acell("B99", choral_counter)
accountability_sheet.update_acell("B100", string_counter)
accountability_sheet.update_acell("B101", jazz_counter)
accountability_sheet.update_acell("B102", solo_counter)
accountability_sheet.update_acell("B103", full_orch_counter)


finished_sku_counter = 0
monthly_page_count = 0


for item in range(len(release_plan_sheet.col_values(7))):
    dev_status = release_plan_sheet.cell((item + 1), 7).value
    title = release_plan_sheet.cell((item + 1), 2).value
    sku_page_count = release_plan_sheet.cell((item + 1), 6).value

    if dev_status == "REL":
        finished_sku_counter = finished_sku_counter + 1
        if sku_page_count == "":
            sku_page_count = 0
        monthly_page_count = monthly_page_count + int(sku_page_count)

    if dev_status == "RFA":
        finished_sku_counter = finished_sku_counter + 1
        if sku_page_count == "":
            sku_page_count = 0
        monthly_page_count = monthly_page_count + int(sku_page_count)

    if dev_status == "RFFT":
        finished_sku_counter = finished_sku_counter + 1
        if sku_page_count == "":
            sku_page_count = 0
        monthly_page_count = monthly_page_count + int(sku_page_count)

    if dev_status == "OFA":
        finished_sku_counter = finished_sku_counter + 1
        if sku_page_count == "":
            sku_page_count = 0
        monthly_page_count = monthly_page_count + int(sku_page_count)

accountability_sheet.update_acell("D101", str(finished_sku_counter))
accountability_sheet.update_acell("D105", str(monthly_page_count))

stephanie_dev_count = 0
stephanie_qa_count = 0
peter_dev_count = 0
peter_qa_count = 0
anna_dev_count = 0
anna_qa_count = 0
cj_dev_count = 0
cj_qa_count = 0
michael_dev_count = 0
michael_qa_count = 0
al_dev_count = 0
al_qa_count = 0
adrian_dev_count = 0
adrian_qa_count = 0
catch_all_dev = 0
catch_all_qa = 0

current_number_of_titles = 0

for item in range(len(release_sku_col)):
    sku_col_as_string = str(release_sku_col[item])
    sku_name_as_string = str(release_name_col[item])
    if sku_col_as_string.isdigit():
        current_number_of_titles = current_number_of_titles + 1
        qa_sheet_title = sku_col_as_string + " - " + sku_name_as_string
        try:
            QA_sheet = client.open(qa_sheet_title).sheet1
            dev_name = str(QA_sheet.acell("D3")).lower()
            dev_name = dev_name[12:-2]
            qa_name = str(QA_sheet.acell("A3")).lower()
            qa_name = qa_name[12:-2]
            if dev_name == "sdoctor":
                stephanie_dev_count = stephanie_dev_count + 1
            if qa_name == "sdoctor":
                stephanie_qa_count = stephanie_qa_count + 1
            if dev_name == "pflom":
                peter_dev_count = peter_dev_count + 1
            if qa_name == "pflom":
                peter_qa_count = peter_qa_count + 1
            if dev_name == "asmith":
                anna_dev_count = anna_dev_count + 1
            if dev_name == "annasmith":
                anna_dev_count = anna_dev_count + 1
            if qa_name == "asmith":
                anna_qa_count = anna_qa_count + 1
            if qa_name == "annasmith":
                anna_qa_count = anna_qa_count + 1
            if dev_name == "cgarcia":
                cj_dev_count = cj_dev_count + 1
            if qa_name == "cgarcia":
                cj_qa_count = cj_qa_count + 1
            if dev_name == "michael muth":
                michael_dev_count = michael_dev_count + 1
            if qa_name == "michael muth":
                michael_qa_count = michael_qa_count + 1
            if dev_name == "anigro":
                al_dev_count = al_dev_count + 1
            if qa_name == "anigro":
                al_qa_count = al_qa_count + 1
            if dev_name == "Saqeef":
                catch_all_dev = catch_all_dev + 1
            if qa_name == "Saqeef":
                catch_all_qa = catch_all_qa + 1
            if dev_name == "bgohman":
                catch_all_dev = catch_all_dev + 1
            if qa_name == "bgohman":
                catch_all_qa = catch_all_qa + 1
        except gspread.SpreadsheetNotFound:
            # print("***" + qa_sheet_title + ": NOT CREATED\n" + "MPE: " + "\n" + "QA: " + "\n")
            continue
        # print(qa_sheet_title + "\n" + "MPE: " + dev_name + "\n" + "QA: " + qa_name + "\n")
    else:
        continue

# print("Peter DEV:", peter_dev_count, "\n", "Peter QA:", peter_qa_count, "\n")
accountability_sheet.update_acell("F98", str(peter_dev_count))
accountability_sheet.update_acell("G99", str(peter_qa_count))
# print("Stephanie DEV:", stephanie_dev_count, "\n", "Stephanie QA:", stephanie_qa_count, "\n")
accountability_sheet.update_acell("F99", str(stephanie_dev_count))
accountability_sheet.update_acell("G99", str(stephanie_qa_count))
# print("Anna DEV:", anna_dev_count, "\n", "Anna QA:", anna_qa_count, "\n")
accountability_sheet.update_acell("F100", str(anna_dev_count))
accountability_sheet.update_acell("G100", str(anna_qa_count))
# print("CJ DEV:", cj_dev_count, "\n", "CJ QA:", cj_qa_count, "\n")
accountability_sheet.update_acell("F101", str(cj_dev_count))
accountability_sheet.update_acell("G101", str(cj_qa_count))
# print("Michael DEV:", michael_dev_count, "\n", "Michael QA:", michael_qa_count, "\n")
accountability_sheet.update_acell("F102", str(michael_dev_count))
accountability_sheet.update_acell("G102", str(michael_qa_count))
# print("Al DEV:", al_dev_count, "\n", "Al QA:", al_qa_count, "\n")
accountability_sheet.update_acell("F103", str(al_dev_count))
accountability_sheet.update_acell("G103", str(al_qa_count))
# print("Catchall DEV:", catch_all_dev, "\n", "Catchall QA:", catch_all_qa, "\n")
accountability_sheet.update_acell("F104", str(catch_all_dev))
accountability_sheet.update_acell("G104", str(catch_all_qa))

# print("Current Number of Titles: ", current_number_of_titles)
accountability_sheet.update_acell("D98", str(current_number_of_titles))


# Create new spreadsheet with { "properties": { "title": "xxGoogleAPIMasterTemplatexx" } } using service.spreadsheets().create().
# File ID and filename can be returned.
# Copy the template spreadsheet to the new spreadsheet using service.spreadsheets().sheets().copyTo().
