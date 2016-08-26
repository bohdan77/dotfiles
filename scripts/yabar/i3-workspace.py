import ujson, subprocess, sys
from time import sleep

def shell(cmd):
    return subprocess.Popen(cmd, shell = True, stdout = subprocess.PIPE).stdout.read().rstrip()

def getWorkspaceJSON():
    workspacesPayload = shell('i3-msg -t get_workspaces')
    return ujson.loads(workspacesPayload)
    

workspace_icons = {1 : '', 2 : '', 3 : '', 0 : '', 4 : ''}

current_workspace_id = 0


while True:

    for x in getWorkspaceJSON():
        if x['visible']:
            current_workspace_id = x['num']
            break

    if current_workspace_id >= len(workspace_icons):
        current_workspace_id = 0
    
        
    
    print(workspace_icons.get(current_workspace_id))
    

    sleep(0.3)
