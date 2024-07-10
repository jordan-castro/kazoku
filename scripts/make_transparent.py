# This script is for making a image background transparent.
# usage: make_transparent.py <path_to_image> <background_color> (as hex)

from PIL import Image, ImageColor
import sys

image = Image.open(sys.argv[1])
image = image.convert("RGBA")
bg_color = ImageColor.getcolor(sys.argv[2], "RGB")

# Loop through pixels
width, height = image.size

for x in range(width):
    for y in range(height):
        current_color = image.getpixel((x,y))
        if current_color[:3] == bg_color[:3]:
            image.putpixel((x,y), (0, 0, 0, 0))

image.save(sys.argv[1])