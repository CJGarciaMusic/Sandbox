import random
import datetime
from slackclient import SlackClient

greeting = ["crew", "team", "folks", "everyone", "gang", "fellow coworkers", "happy faces", "lovely people", "RepDev-ers", "P'Zone lovers", "sarcastically enthusiastic flat-earthers"]

today = datetime.date.today()

formatted_day = today.strftime("%A %B %d, %Y")

message = "Good morning {}!\n\nHere is the stand-up order for {}:\n".format(random.choice(greeting), formatted_day)

name_list = ["Peter", "CJ", "???", "Koby", "Austin"]
dev_on_deck = ["Koby", "CJ", "Peter", "Austin"]
peter_emoji = [":doge:", ":ravioli_love:"]

order = list(range(len(name_list) + 1))

random.shuffle(name_list)

final_list = zip(order[1:], name_list)

rand_name = ""

for item in final_list:
    item = str(item).replace("(", "")
    item = str(item).replace(")", "")
    item = str(item).replace("'", "")
    item = str(item).replace(",", ".")
    rand_name = rand_name + item + ("\n")


if "Monday" in formatted_day:
    on_deck_name = dev_on_deck[3]
    name_with_emoji = on_deck_name+" :trumpet:"
elif "Tuesday" in formatted_day:
    on_deck_name = dev_on_deck[1]
    name_with_emoji = on_deck_name+" :triforce:"
elif "Wednesday" in formatted_day:
    on_deck_name = dev_on_deck[2]
    name_with_emoji = on_deck_name+" {}".format(random.choice(peter_emoji))
elif "Thursday" in formatted_day:
    on_deck_name = dev_on_deck[3]
    name_with_emoji = on_deck_name+" :trumpet:"
elif "Friday" in formatted_day:
    on_deck_name = dev_on_deck[1]
    name_with_emoji = on_deck_name+" :triforce:"
    # on_deck_name = random.choice(dev_on_deck)
    # if on_deck_name == "Koby":
    #     name_with_emoji = ":sparkles:"+on_deck_name+":sparkles:"
    # elif on_deck_name == "CJ":
    #     name_with_emoji = on_deck_name+" :triforce:"
    # elif on_deck_name == "Peter":
    #     name_with_emoji = on_deck_name+" {}".format(random.choice(peter_emoji))
    # elif on_deck_name == "Austin":
    #     name_with_emoji = on_deck_name+" :trumpet:"


on_deck_message = "Today's Dev on Deck is {}".format(on_deck_name)
on_deck_message_with_emoji = "Today's Dev on Deck is {}".format(name_with_emoji)

# print(message + rand_name)

# print(on_deck_message)

token = "xoxp-3253498392-43698601137-614820279462-3f3659afbd299f03e8343b183897ea5a"
sc = SlackClient(token)

sc.api_call(
    "chat.postMessage",
    link_names = 1,
    channel = "C19KFP9L4",
    text = on_deck_message_with_emoji,
    as_user = True
    )

slack_names = ["D1KLU7K5L", "DG57WT326", "D40D5RMGE", "DF4JPNDJA", "D47MDPBBJ"]
# D1KLU7K5L - CJ
# DG57WT326 - Kaitlyn
# D40D5RMGE - Peter
# DF4JPNDJA - Koby
# D3HMF8A0J - Liz
# D47MDPBBJ - Austin
# D1G0210JD - Mark
# C19KFP9L4 - SM-Debigging-channel

if "Wednesday" not in formatted_day:
    for sn in slack_names:
        sc.api_call(
        "chat.postMessage",
        link_names = 1,
        channel = sn,
        text = message + rand_name,
        as_user = True
        )