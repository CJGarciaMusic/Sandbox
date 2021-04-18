# import requests
# import urllib.parse
# from bs4 import BeautifulSoup

# res = requests.get("https://www.jwpepper.com/sheet-music/services-state-festival.jsp")

# soup = BeautifulSoup(res.content, "html.parser")


# # # prints the state list name and website
# state_list_website = soup.find(class_="states-holder")

# state_name = state_list_website.find_all("a")

# state_website = []
# state_abbr = []

# for item in state_name:
#     state = item.contents[0]
#     link = "https://www.jwpepper.com" + item.get("href")
#     state_website.append(link)
#     state_abbr.append(state)
#     # print(state + ":", link)

# links_to_run_scrapping = []

# """
# state_index = 0
# for item in state_website:
#     # state_file = open("/Users/cgarcia/Google Drive/RepDev Python Scripts/State Lists/{} State List.txt".format(state_abbr[state_index]), "w")

#     res_level_one = requests.get(item)

#     soup_level_one = BeautifulSoup(res_level_one.content, "html.parser")

#     single_state_festival_list = soup_level_one.find(class_="list-select-cont")

#     festival_names = single_state_festival_list.find_all("option")

#     state_list_of_list = single_state_festival_list.find_all(class_="sfgroups")

#     for fest_group in state_list_of_list:
#         whole_tag = fest_group.find_all("a")
#         list_name = str(fest_group.find("h1")).replace("<h1>", "")
#         # state_file.write(list_name.replace("</h1>", "") + "\n")
#         for group_link in whole_tag:
#             name = group_link.contents[0]
#             jw_link = "https://www.jwpepper.com" + group_link.get("href")
#             full_link = jw_link.replace(" ", "%20")
#             links_to_run_scrapping.append(full_link)
#             # state_file.write(name)
#             # state_file.write(full_link)

#     for fest_name in festival_names[1:]:
#         name = fest_name.contents[0]
#         link_key = urllib.parse.quote(fest_name.get("value"))
#         host = "https://www.jwpepper.com/sheet-music/search.jsp?state={}&festival={}&sflist={}"
#         fest_num = link_key[4:]
#         link_again = host.format(fest_num, state_abbr[state_index], link_key)
#         # state_file.write(name)
#         # state_file.write(link_again)

#     state_index = state_index + 1
#     # state_file.close()
# """

# test_list = ['https://www.jwpepper.com/sheet-music/search.jsp?state=AL&sflist=AL2B2&stategroupname=Alabama%20Bandmasters&statelist=AL.B.NEW.CLASSAA&stategroup=AL.B.']

# for item in test_list:
#     res_level_two = requests.get(item)
#     soup_level_two = BeautifulSoup(res_level_two.content, "html.parser")
#     top_right_details = soup_level_two.find_all(class_="top-right-details")
#     for details in top_right_details:
#         piece_title = details.find("a").contents[0]
#         publisher = details.find(class_="publisher-name").contents[0]
#         print("Title:", piece_title, "\n", "Publisher:", publisher, "\n", "\n")

#         get_more_info = soup_level_two.find_all(class_="results-linked-grid-wrapper")
#         for more_info in get_more_info:
#             pepper_level_start = more_info.find(class_="prodLevel")

#             print("Pepper Level:", pepper_level_start)
