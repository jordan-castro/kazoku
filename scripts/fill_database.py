import os
from glob import glob
from PIL import Image, ImageColor

def rgb_to_hex(rgb):
    r,g,b,a = rgb

    # Ensure RGB values are within the range 0 to 255
    if 0 <= r <= 255 and 0 <= g <= 255 and 0 <= b <= 255:
        return f'#{r:02x}{g:02x}{b:02x}'
    else:
        raise ValueError("RGB values must be in the range 0 to 255")

starting_number = 198

images = glob("assets/images/sprites/character/outfit/*")
top_point = (47, 49)
bottom_point = (47, 56)
for img_path in images:
    img = Image.open(img_path)
    file_name = ""
    if "\\" in img_path:
        file_name = img_path.split("\\")[-1]
    elif "/" in img_path:
        file_name = img_path.split("/")[-1]
    top_color = rgb_to_hex(img.getpixel(top_point))
    bottom_color = rgb_to_hex(img.getpixel(bottom_point))
    object_type = file_name.split("_")[0].lower()
    object_name = file_name.split("_")[0:2]
    object_name[1] = int(object_name[1])
    object_name = object_name[0] + " " + str(object_name[1])

    data = {
        "top_color": top_color,
        "bottom_color": bottom_color
    }

    print(f"({starting_number}, \"{object_name}\", \"{object_type}\", \"{img_path.replace("assets/images/", "").replace("\\", "/")}\", \"{data}\", 0),")
    starting_number += 1