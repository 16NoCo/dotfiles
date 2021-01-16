# -*- coding: utf-8 -*-

"""
BroTab search
"""

import subprocess
from collections import namedtuple
from shutil import which
from functools import reduce
import re
import os

from albertv0 import *

__iid__ = "PythonInterface/v0.1"
__prettyname__ = "BroTab2"
__version__ = "1.0"
__author__ = "Noé Cornet"
__dependencies__ = ["brotab"]

dirpath = os.path.dirname(__file__)
script = os.path.join(dirpath,"switch-to-tab.sh")
icon = os.path.join(dirpath,"firefox_tab.svg")

Tab = namedtuple("Tab", ["tabid", "title", "url"])

if which("brotab") is None:
    raise Exception("'brotab' is not in $PATH.")

def handleQuery(query):
    stripped = query.string.strip().lower()
    if stripped:
        results = []
        for line in subprocess.check_output(['brotab', 'list']).splitlines():
            tab = Tab(*[token for token in line.decode().split("\t",2)])
            if stripped in tab.title.lower()+tab.url.lower():

                description = "%s %s" % (tab.title.lower(), tab.url.lower())
                description = "%s" % (tab.url.lower())
                score, matchPos = calculateScore(description, stripped)
                text = highlightText(tab,matchPos)

                results.append(Item(id="%s%s" % (__prettyname__, tab.tabid),
                        icon=icon,
                        **text,
                        actions=[ProcAction("Go to Tab",
                                            [script, tab.tabid])]))
        return results


def highlightText(tab, spans):
    '''
    input: 
    spans: list(tuple(int, int)) - describing match positions
    '''

    # sort spans
    spans.sort(key=lambda x: x[0])
    
    # check spans not overlapping, this could be problem when doing fuzzy search

    text='<b>Tab</b>: %s' % (tab.title)
    subtext=''

    description = '%s' % (tab.url)
    #len_wm_class = len(win.wm_class.split('.')[-1].lower())

    last_pos = 0

    for s_init, s_end in spans:
        before = description[last_pos:s_init]
        highlight = description[s_init:s_end]

        subtext+='%s<u>%s</u>'% (before, highlight)
        last_pos = s_end

    subtext += description[last_pos:]
    return {'text':text, 'subtext':subtext }


def createRegExp(query_token):
    regex = ''
    matchFuzzy = False
    if matchFuzzy:
        query_token = [re.escape(x) for x in list(query_token)]
    else:
        query_token = [re.escape(query_token)]

    regex = reduce(lambda a,b: a + '[^' + b + ']*' + b, query_token)
    # print(regex)
    return regex

def calculateScore(description, query_token):
    if query_token == '':
        return True
    regexp = createRegExp(query_token)
    # print(regex)

    score = 0
    gotMatch = False
    spans = []

    for match in re.finditer(regexp, description,flags=re.I):
        # print('%s -> matches: %s'%(regexp, match))
        # A full match at the beginning is the best match
        if (match.start() == 0 and len(match.group(0)) == len(query_token)):
            score += 100
        
         # matches at beginning word boundaries are better than in the middle of words
        if( match.start() == 0 or (match.start != 0 and description[match.start() - 1] == ' ')):
            wordPrefixFactor = 1.2
        else:
            wordPrefixFactor = 0.0

        # matches nearer to the beginning are better than near the end
        precedenceFactor = 1.0 / (1 + match.start())

        # fuzzyness can cause lots of stuff to match, penalize by match length
        fuzzynessFactor = (2.3 * (len(query_token) - len(match.group(0))  )) / len(match.group(0))

        # join factors by summing
        newscore = precedenceFactor + wordPrefixFactor + fuzzynessFactor
        score = max(score, newscore)
        spans.append(match.span())
        gotMatch = True
    return score, spans
