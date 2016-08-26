import subprocess
from time import sleep

battery_icons = ['', '', '', '', '', ''] # unicode font awesome characters, higher indices have fuller batteries
battery_colors = ['5AB45A', 'FFFFFF', 'AF2832'] # green, white, red



def getBatteryStats():
    global battery_now
    global is_charging
    battery_now = int(open('/sys/class/power_supply/BAT0/capacity').read().rstrip())
    is_charging = open('/sys/class/power_supply/BAT0/status').read().rstrip() == "Charging"


battery_icon = ''
battery_color = battery_colors[1] #default is white

while True:
    getBatteryStats()
    if battery_now > 100:
        battery_now = 100
        battery_icon = battery_icons[4]
        battery_color = battery_colors[0]
    elif battery_now > 75:
        battery_icon = battery_icons[3]
    elif battery_now > 50:
        battery_icon = battery_icons[2]
    elif battery_now > 20:    
        battery_icon = battery_icons[1]
    else:
        battery_icon = battery_icons[0]
        battery_color = battery_colors[2]

    if is_charging:
        battery_color = battery_colors[0]
        battery_icon = battery_icons[5]

    color_str = "!Y fg0xFF" + battery_color + " Y!" #color format string





    print(color_str + battery_icon + ' ' + str(battery_now) + "%")
    sleep(2)
