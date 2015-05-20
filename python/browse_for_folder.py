#!/usr/bin/env python
# Browse for a folder in Microsoft Windows
import sys, os
from win32com.shell import shell, shellcon
import win32gui

# callback procedure to set selected
def BrowseCallbackProc(hwnd, msg, lp, data):
    if msg== shellcon.BFFM_INITIALIZED:
        win32gui.SendMessage(hwnd, shellcon.BFFM_SETSELECTION, 1, data)
    elif msg == shellcon.BFFM_SELCHANGED:
        # Set the status text of the
        # For this message, 'lp' is the address of the PIDL.
        pidl = shell.AddressAsPIDL(lp)
        try:
            path = shell.SHGetPathFromIDList(pidl)
            win32gui.SendMessage(hwnd, shellcon.BFFM_SETSTATUSTEXT, 0, path)
        except shell.error:
            # No path for this PIDL
            pass

if __name__=='__main__':
    # Demonstrate a dialog with the cwd selected as the default - this
    # must be done via a callback function.
    flags = shellcon.BIF_STATUSTEXT
    startinDir = None
    if (len(sys.argv) > 1):
    	startinDir = os.path.normpath(' '.join(sys.argv[1:]))
    else:
    	startinDir = os.getcwd()

    shell.SHBrowseForFolder(0, # parent HWND
                            None, # root PIDL.
                            "Default of %s" % startinDir, # title
                            flags, # flags
                            BrowseCallbackProc, # callback function
                            startinDir # 'data' param for the callback
                            )