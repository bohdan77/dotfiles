import subprocess

from tempfile import TemporaryFile

is_muted = ''
current_volume = ''
current_icon = ''

with TemporaryFile() as f:

    p1 = subprocess.Popen("amixer sget Master", stdout = f, shell = True)
    p1.wait()
    f.flush()
    f.seek(0)
    is_muted = f.read().decode('utf-8').rstrip()
    is_muted = is_muted[is_muted.rfind('[') + 1: -1] == "off"
    f.seek(0)
    p2 = subprocess.Popen("awk -F\"[][]\" '/dB/ { print $2 }\'", stdin = f , stdout = subprocess.PIPE, shell = True)

current_volume = int(p2.stdout.read().decode('utf-8').rstrip().replace("%", ''))

volume_icons = ['', '', '']

if current_volume > 50:
    current_icon = volume_icons[2]
elif current_volume > 1:
    current_icon = volume_icons[1]
else:
    current_icon = volume_icons[0]


if is_muted:
    current_icon = volume_icons[0]
    current_volume = "MUTE"

if type(current_volume) is int:
    current_volume = str(current_volume) + "%"


    
print(current_icon + ' ' + current_volume)
