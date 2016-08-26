from mpd import MPDClient
from time import sleep


client = MPDClient()
client.timeout = 10
client.idletimeout = None
client.connect("localhost", 6600)

spotify_icon = ' '

while True:

     current_song = client.currentsong()
     current_status = client.status()
     if current_status['state'] != 'play':
         print('')
     elif current_song:
         print(spotify_icon + current_song['artist'] + ' - ' + current_song['title'])
     else:
         print('')

     client.idle() ##idle so we don't poll
    


client.close()
client.disconnect()

