# This script is to remove the image which is underneath a outfit/eyes/hair/objects image.

from PIL import Image
import sys
from utils import get_file_name, get_rgba_image


# botttom
bottom_image = Image.open(sys.argv[1])
# current
image = get_rgba_image(sys.argv[2])

file_name = get_file_name(sys.argv[2])

bottom_w, bottom_h = bottom_image.size
top_w, top_h = image.size

assert bottom_h == top_h and bottom_w == top_w, "Sizes must match."

tolerance = 5  # You can adjust this tolerance level

def is_similar(pixel1, pixel2, tolerance):
    return all(abs(a - b) <= tolerance for a, b in zip(pixel1[:3], pixel2[:3]))

for x in range(top_w):
    for y in range(top_h):
        point = (x, y)

        bottom_pixel = bottom_image.getpixel(point)
        top_pixel = image.getpixel(point)

        if is_similar(top_pixel, bottom_pixel, tolerance):
            image.putpixel(point, (0, 0, 0, 0))

image.save(file_name)