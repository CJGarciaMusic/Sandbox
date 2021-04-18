import random
import datetime
from slackclient import SlackClient

today = datetime.date.today()

formatted_day = today.strftime("%A %B %d, %Y")

dev_on_deck = ["Koby", "CJ", "Peter", "Austin"]
peter_emoji = [":doge:", ":ravioli_love:"]

if "Monday" in formatted_day:
    on_deck_name = dev_on_deck[0]
    name_with_emoji = ":sparkles:"+on_deck_name+":sparkles:"
elif "Tuesday" in formatted_day:
    on_deck_name = dev_on_deck[1]
    name_with_emoji = on_deck_name+" :triforce:"
elif "Wednesday" in formatted_day:
    on_deck_name = dev_on_deck[3]
    name_with_emoji = on_deck_name+" :trumpet:"
elif "Thursday" in formatted_day:
    on_deck_name = dev_on_deck[2]
    name_with_emoji = on_deck_name+" {}".format(random.choice(peter_emoji))
elif "Friday" in formatted_day:
    friday_list = ["CJ", "Peter", "Austin"]
    on_deck_name = random.choice(friday_list)
    if on_deck_name == "CJ":
        name_with_emoji = on_deck_name+" :triforce:"
    elif on_deck_name == "Peter":
        name_with_emoji = on_deck_name+" {}".format(random.choice(peter_emoji))
    elif on_deck_name == "Austin":
        name_with_emoji = on_deck_name+" :trumpet:"

on_deck_message_with_emoji = "Today's Dev on Deck is {}".format(name_with_emoji)

token = "xoxp-3253498392-43698601137-614820279462-3f3659afbd299f03e8343b183897ea5a"
sc = SlackClient(token)

sc.api_call(
    "chat.postMessage",
    link_names = 1,
    channel = "C19KFP9L4",
    text = on_deck_message_with_emoji,
    as_user = True
    )

# C19KFP9L4 - SM-Debigging-channel