# -*- coding: utf-8 -*-

"""
X11 window switcher - list and activate windows.
"""

import subprocess
import os
from collections import namedtuple
from shutil import which

from albertv0 import *
#import gi
#import sys
#gi.require_version('Gtk', '3.0')
#from gi.repository import Gtk

Window = namedtuple("Window", ["wid", "desktop", "wm_class", "host", "wm_name"])

__iid__ = "PythonInterface/v0.1"
__prettyname__ = "Sublime Projects"
__version__ = "1.4"
__author__ = "Ed Perez, Manuel Schneider"
__dependencies__ = ["subl"]

#icon_name = 'sublime'
#icon_theme = Gtk.IconTheme.get_default()
#icon_path = icon_theme.lookup_icon(icon_name, 48, 0).get_filename()
icon_path = iconLookup('sublime-text')

if which("subl") is None:
    raise Exception("'subl' is not in $PATH.")

def handleQuery(query):
    stripped = query.string.strip().lower()
    if stripped:
        results = []
        
        for root, dirs, files in os.walk("/home/noe/Documents/"):
            for file in files:
                if file.endswith('.sublime-project') and stripped in file.lower():
                    results.append(Item(id="%s%s" % (__prettyname__, file.split('.')[0]),
                                        text="%s - Sublime Project" % (file.split('.')[0]),
                                        icon=icon_path,
                                        subtext=root+"/",
                                        actions=[ProcAction("Open Project",
                                                            ["subl", '--project', os.path.join(root,file)]),
                                                 ProcAction("Open file (vim)",
                                                            ["vim", os.path.join(root,file)])]))
        return results
