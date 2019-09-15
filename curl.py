import requests
from xml.dom import minidom  
import re  

r = requests.get("http://www.musicprep.com/jetpack")
url_text = r.text
original_version = 0.78
new_version = float

for line in url_text.splitlines():
    if "VERSION" in (line):
        more_lines = line.split(">")
        for item in more_lines:
            if "VERSION" in item:
                new_version = float((re.sub("[^0-9, .]", "", item)))

if original_version == new_version:
    print("You are up to date!")
elif new_version > original_version:
    print("Time to Update!")
elif new_version < original_version:
    print("Somehow, you have a version newer than what's currently being offered. How'd you do that...?")