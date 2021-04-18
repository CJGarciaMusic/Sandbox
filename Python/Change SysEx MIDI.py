import mido
import os
import subprocess
from mido import MidiFile

# sku_num = input("Please enter your sku: ")

def move_sysex(midi_file):
    path = "/_Source/391/391_build/"+midi_file
    mid = MidiFile(path)

    track_type = []

    for i, track in enumerate(mid.tracks):
        print('Track {}: {}'.format(i, track.name))
        for msg in track:
            if msg.type == "sysex":
                track_type.append(msg)
            
    if len(track_type) == 0:
        return

    offset = 480
    beat = 480
    numerator = 0
    denominator = 0

    # conductor track
    for msg in mid.tracks[0]:
        if msg.type == "time_signature":
            numerator = int(msg.numerator)
            denominator = int(msg.denominator)
        if "SOF" in str(msg):
            if denominator == 4:
                offset = msg.time
            else:
                offset = 0

    if denominator == 8:
        beat = int(beat / 2)
    elif denominator == 16:
        beat = int(beat / 4)
    elif denominator == 2:
        beat = int(beat * 2)    

    if offset == 0:
        offset = beat * numerator

    for i, track in enumerate(mid.tracks):
        print('Track {}: {}'.format(i, track.name))
        for msg in track:
            print(msg)
        first_sys = []
        rest_of_sys = []
        for msg in track:
            if msg.type == "sysex":
                if msg.time == 0:
                    first_sys.append(msg)
                else:
                    rest_of_sys.append(msg)
        if len(first_sys) >= 1:
            first_sys[0].time = offset
            if len(rest_of_sys) >= 1:
                for item in rest_of_sys:
                    item.time = item.time - offset

    mid.save(path)

sku_list = ["391_t200.MID",
"391_t340.MID",
"391_t336.MID",
"391_t332.MID",
"391_t328.MID",
"391_t324.MID",
"391_t320.MID",
"391_t316.MID",
"391_t339.MID",
"391_t335.MID",
"391_t331.MID",
"391_t327.MID",
"391_t323.MID",
"391_t319.MID",
"391_t315.MID",
"391_t311.MID",
"391_t307.MID",
"391_t303.MID",
"391_t341.MID",
"391_t337.MID",
"391_t333.MID",
"391_t329.MID",
"391_t325.MID",
"391_t321.MID",
"391_t317.MID",
"391_t342.MID",
"391_t338.MID",
"391_t334.MID",
"391_t330.MID",
"391_t326.MID",
"391_t322.MID",
"391_t318.MID",
"391_t312.MID",
"391_t308.MID",
"391_t304.MID",
"391_t313.MID",
"391_t309.MID",
"391_t305.MID",
"391_t314.MID",
"391_t310.MID",
"391_t306.MID",
"391_t295.MID",
"391_t291.MID",
"391_t283.MID",
"391_t271.MID",
"391_t267.MID",
"391_t263.MID",
"391_t300.MID",
"391_t296.MID",
"391_t292.MID",
"391_t288.MID",
"391_t284.MID",
"391_t280.MID",
"391_t272.MID",
"391_t268.MID",
"391_t264.MID",
"391_t260.MID",
"391_t301.MID",
"391_t297.MID",
"391_t293.MID",
"391_t289.MID",
"391_t285.MID",
"391_t281.MID",
"391_t277.MID",
"391_t273.MID",
"391_t269.MID",
"391_t261.MID",
"391_t302.MID",
"391_t294.MID",
"391_t290.MID",
"391_t286.MID",
"391_t282.MID",
"391_t274.MID",
"391_t270.MID",
"391_t266.MID",
"391_t262.MID",
"391_t258.MID",
"391_t254.MID",
"391_t250.MID",
"391_t246.MID",
"391_t242.MID",
"391_t259.MID",
"391_t255.MID",
"391_t251.MID",
"391_t247.MID",
"391_t243.MID",
"391_t239.MID",
"391_t235.MID",
"391_t223.MID",
"391_t219.MID",
"391_t215.MID",
"391_t211.MID",
"391_t207.MID",
"391_t203.MID",
"391_t199.MID",
"391_t195.MID",
"391_t256.MID",
"391_t252.MID",
"391_t248.MID",
"391_t244.MID",
"391_t240.MID",
"391_t236.MID",
"391_t228.MID",
"391_t224.MID",
"391_t257.MID",
"391_t253.MID",
"391_t249.MID",
"391_t245.MID",
"391_t241.MID",
"391_t237.MID",
"391_t233.MID",
"391_t229.MID",
"391_t225.MID",
"391_t238.MID",
"391_t234.MID",
"391_t230.MID",
"391_t222.MID",
"391_t220.MID",
"391_t216.MID",
"391_t221.MID",
"391_t217.MID"
"391_t213.MID",
"391_t209.MID",
"391_t205.MID",
"391_t201.MID",
"391_t197.MID",
"391_t218.MID",
"391_t214.MID",
"391_t210.MID",
"391_t206.MID",
"391_t202.MID",
"391_t198.MID",
"391_t194.MID",
"391_t190.MID",
"391_t186.MID",
"391_t191.MID",
"391_t187.MID",
"391_t183.MID",
"391_t179.MID",
"391_t175.MID",
"391_t212.MID",
"391_t208.MID",
"391_t204.MID",
"391_t196.MID",
"391_t192.MID",
"391_t188.MID",
"391_t184.MID",
"391_t180.MID",
"391_t176.MID",
"391_t172.MID",
"391_t178.MID",
"391_t174.MID",
"391_t193.MID",
"391_t189.MID",
"391_t185.MID",
"391_t177.MID",
"391_t173.MID",
"391_t168.MID",
"391_t164.MID",
"391_t160.MID",
"391_t156.MID",
"391_t152.MID",
"391_t148.MID",
"391_t144.MID",
"391_t132.MID",
"391_t128.MID",
"391_t124.MID",
"391_t116.MID",
"391_t112.MID",
"391_t104.MID",
"391_t100.MID",
"391_t096.MID",
"391_t092.MID",
"391_t088.MID",
"391_t084.MID",
"391_t080.MID",
"391_t076.MID",
"391_t069.MID",
"391_t057.MID",
"391_t053.MID",
"391_t049.MID",
"391_t170.MID",
"391_t166.MID",
"391_t162.MID",
"391_t171.MID",
"391_t167.MID",
"391_t163.MID",
"391_t169.MID",
"391_t165.MID",
"391_t161.MID",
"391_t159.MID",
"391_t155.MID",
"391_t157.MID",
"391_t158.MID",
"391_t154.MID",
"391_t150.MID",
"391_t146.MID",
"391_t151.MID",
"391_t147.MID",
"391_t153.MID",
"391_t149.MID",
"391_t143.MID",
"391_t142.MID",
"391_t145.MID",
"391_t135.MID",
"391_t133.MID",
"391_t129.MID",
"391_t131.MID",
"391_t134.MID",
"391_t130.MID",
"391_t127.MID",
"391_t125.MID",
"391_t126.MID",
"391_t117.MID",
"391_t115.MID",
"391_t111.MID",
"391_t113.MID",
"391_t114.MID",
"391_t110.MID",
"391_t109.MID",
"391_t105.MID",
"391_t103.MID",
"391_t099.MID",
"391_t101.MID",
"391_t097.MID",
"391_t102.MID",
"391_t098.MID",
"391_t095.MID",
"391_t091.MID",
"391_t093.MID",
"391_t094.MID",
"391_t087.MID",
"391_t089.MID",
"391_t085.MID",
"391_t090.MID",
"391_t086.MID",
"391_t083.MID",
"391_t079.MID",
"391_t081.MID",
"391_t082.MID",
"391_t075.MID",
"391_t077.MID",
"391_t073.MID",
"391_t078.MID",
"391_t074.MID",
"391_t068.MID",
"391_t067.MID",
"391_t056.MID",
"391_t052.MID",
"391_t054.MID",
"391_t050.MID",
"391_t055.MID",
"391_t051.MID",
"391_t072.MID",
"391_t071.MID",
"391_t070.MID"]

for item in sku_list:
    # file = "/_Source/391/391_build/{}".format(item)
    if "MID" in item:
        print("Begin work on", item)
        move_sysex(item)
        print("Done working on", item)
