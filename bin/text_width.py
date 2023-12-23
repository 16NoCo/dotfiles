#!/usr/bin/python

from PIL import ImageFont, ImageDraw, Image
import sys

def get_pil_text_size(text, font_size, font_name):
    font = ImageFont.truetype(font_name, font_size)
    size = font.getsize(text)
    return size[0]

if sys.argv[1]=="-max":
    max_len=0
    for opt in sys.argv[2].replace('\\n','\n').split('\n'):
        len=get_pil_text_size(opt, int(sys.argv[3]), sys.argv[4])
        max_len=max(len,max_len)
    print(max_len)
else:
    print(get_pil_text_size(sys.argv[1], int(sys.argv[2]), sys.argv[3]))
