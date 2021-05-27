import random
import datetime

# import calendar
# import smtplib
# from email.mime.text import MIMEText

# server = smtplib.SMTP("smtp.gmail.com", 587)
#
# server.starttls()
#
# sender_email = "cgarcia@makemusic.com"
# sender_passowrd = "YOUR PASSWORD HERE"
#
# recipients = ["pflom@makemusic.com", "lknutson@makemusic.com", "madler@makemusic.com", "ataylor@makemusic.com", "sdoctor@makemusic.com", "cgarcia@makemusic.com"]
#
# server.login(sender_email, sender_passowrd)


greeting = ["crew", "team", "folks", "everyone", "gang", "fellow coworkers", "happy faces", "lovely people", "RepDev-ers"]

today = datetime.date.today()

formatted_day = today.strftime("%A %B %d, %Y")

message = "Good morning {}!\n\nHere is the stand-up order for {}:\n".format(random.choice(greeting), formatted_day)

name_list = ["Liz", "Peter", "Mark", "CJ", "Kaitlyn", "Koby", "Austin"]
dev_on_deck = ["Peter", "CJ", "Koby", "Austin"]

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
    on_deck_name = dev_on_deck[0]
elif "Tuesday" in formatted_day:
    on_deck_name = dev_on_deck[1]
elif "Wednesday" in formatted_day:
    on_deck_name = dev_on_deck[2]
elif "Thursday" in formatted_day:
    on_deck_name = dev_on_deck[3]
elif "Friday" in formatted_day:
    on_deck_name = random.choice(dev_on_deck)

on_deck_message = "And today's Dev on Deck is {}".format(on_deck_name)

print(message + rand_name)

print(on_deck_message)


# full_message = MIMEText(message + rand_name, "\n", on_deck_message)
# full_message["Subject"] = "Stand-up {}".format(formatted_day)
# full_message["From"] = sender_email
# full_message["To"] = ", ".join(recipients)

# server.sendmail(sender_email, recipients, str(full_message))
# server.quit()