# This file organizes our assets files.
# This is done by placing a (12,13,14) RGB border by ever x and y

from PIL import Image

border_color = (12,13,14)

x_size = 33
y_size = 47

x_amount = 56
y_amount = 20

width = x_size * x_amount
height = y_size * y_amount

image = Image.new("RGBA", (width, height), (0,0,0,0))

for x in range(width):
    for y in range(height):
        if x % x_size == 0:
            image.putpixel((x,y), border_color)
        if y % y_size == 0:
            image.putpixel((x,y), border_color)


image.save("trans.png")