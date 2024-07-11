# This script removes the colors from an image
import sys
from PIL import Image, ImageColor


file_path = sys.argv[1]

image = Image.open(file_path)
image = image.convert("RGBA")
colors = sys.argv[2]

colors = colors.split(",")
colors = [ImageColor.getcolor(color, "RGB") for color in colors]

width, height = image.size

# Go through colors
for x in range(width):
    for y in range(height):
        pixel = image.getpixel((x,y))
        if not pixel[:3] in colors:
            image.putpixel((x,y), (0,0,0,0))

file_name = "image.png"
if "\\" in file_path:
    file_name = file_path.split("\\")[-1]
elif "/" in file_path:
    file_name = file_path.split("/")[-1]

image.save(file_name)