import ujson, subprocess, sys, i3ipc
from time import sleep


workspace_icons = {1 : '', 2 : '', 3 : '', 0 : '', 4 : ''}

current_workspace_id = 0

i3 = i3ipc.Connection()

def on_workspace_focus(self, e):
    global current_workspace_id
    
    if e.current:
        num = e.current.num
        if num != current_workspace_id:
            current_workspace_id = num
            if current_workspace_id >= len(workspace_icons):
                current_workspace_id = 0
            print(workspace_icons.get(current_workspace_id))
    
    


i3.on('workspace::focus', on_workspace_focus)    



i3.main()
