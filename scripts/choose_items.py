########### Imports ###########

from tkinter import Tk, Frame, Canvas, CENTER, Button, NW, Label, SOLID, Scrollbar, VERTICAL, HORIZONTAL
from tkinter import colorchooser, filedialog, OptionMenu, messagebox
from tkinter import DOTBOX, StringVar, simpledialog
from PIL import Image, ImageTk

import os

########### Window Settings ###########

root = Tk()

screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()

root.title("Paint - ECTS v1.0")
root.geometry(f"{screen_width}x{screen_height}")

root.resizable(True, True)

########### Functions ###########

# Variables
prevPoint = [0, 0]
currentPoint = [0, 0]

penColor = "black"
stroke = 1

canvas_data = []

shapeSelect = StringVar()
shapeList = ["None", "Square", "Circle/Oval", "Rectangle", "Line"]
shapeSelect.set("None")
shapeFill = "black"
width = 0
height = 0


# Clear Screen
def clearScreen():
    canvas.delete("all")


# Opening already or earlier made ects files
def openEcts():
    global canvas_data
    file_path = filedialog.askopenfilename(
        filetypes = [
            ("PNG files", "*.png"),
            ("JPG files", "*.jpg"),
        ],
    )
    if file_path:
        image = Image.open(file_path)
        tk_image = ImageTk.PhotoImage(image)
        canvas.create_image(0, 0, anchor=NW, image=tk_image)
        canvas.image = tk_image
        canvas.config(scrollregion=canvas.bbox("all"))


# Asking Shape Dimentions
def askShapeDimention():
    global width, height

    width = simpledialog.askinteger(
        "ECTS - Paint App", f"Enter Width for canvas"
    )

    height = simpledialog.askinteger(
        "ECTS - Paint App", f"Enter Height for canvas"
    )
    if width and height:
        canvas.config(width=width, height=height)


# Binding mouse wheel scrolling to the canvas
def _on_mouse_wheel(event):
    canvas.yview_scroll(int(-1 * (event.delta / 120)), "units")


# Select a portion of the canvas
def select():
    pass


########### Paint App ###########

#### Paint Tools Frame ####

# Main Frame
frame1 = Frame(root, height=150, width=1100)
frame1.grid(row=0, column=0)

# Holder Frame
holder = Frame(frame1, height=120, width=screen_width - 100, bg="white", padx=6, pady=10)
holder.grid(row=0, column=0, sticky=NW)
holder.place(relx=0.5, rely=0.5, anchor=CENTER)

holder.columnconfigure(0, minsize=120)
holder.columnconfigure(1, minsize=120)
holder.columnconfigure(2, minsize=120)
holder.columnconfigure(3, minsize=120)
holder.columnconfigure(4, minsize=120)

holder.rowconfigure(0, minsize=30)

#### Tools ####

# Label for Tool 1,2,3
label123 = Label(holder, text="TOOLS", borderwidth=1, relief=SOLID, width=15)
label123.grid(row=0, column=0)

# Tool 1 - Selector
selector_button = Button(holder, text="Select", height=1, width=12, command=select)
selector_button.grid(row=1, column=0)

#### FILE ACTIONS ####

# Label for Tool 4,5,6
label456 = Label(holder, text="FILE", borderwidth=1, relief=SOLID, width=15)
label456.grid(row=0, column=1)

# Tool 5 - Open File
openButton = Button(holder, text="OPEN", height=1, width=12, command=openEcts)
openButton.grid(row=2, column=1)

#### OTHER ####

# Label for Tool 7 and 8
label7 = Label(holder, text="OTHER", borderwidth=1, relief=SOLID, width=15)
label7.grid(row=0, column=2)

# Tool 7 - Clear Screen
clearButton = Button(holder, text="CLEAR", height=1, width=12, command=clearScreen)
clearButton.grid(row=1, column=2)

# Tool 8 - Exit App
exitButton = Button(
    holder, text="Exit", height=1, width=12, command=lambda: root.destroy()
)
exitButton.grid(row=2, column=2)

#### Stroke Size ####

# Label for Tool 8, 9 and 10
label8910 = Label(holder, text="STROKE SIZE", borderwidth=1, relief=SOLID, width=15)
label8910.grid(row=0, column=3)

#### Shapes ####

# Label for Tool 11,12,13
label1123 = Label(holder, text="SHAPES", borderwidth=1, relief=SOLID, width=15)
label1123.grid(row=0, column=4)

# Tool 11 - shapeSelector
shapeMenu = OptionMenu(holder, shapeSelect, *shapeList)
shapeMenu.grid(row=1, column=4)
shapeMenu.config(width=8)

# Tool 9 - Decreament by 1
dimentionButton = Button(
    holder, text="Dimention", height=1, width=12, command=askShapeDimention
)
dimentionButton.grid(row=2, column=4)

#### Canvas Frame ####

# Main Frame
frame2 = Frame(root)
frame2.grid(row=1, column=0, sticky="nsew")
frame2.rowconfigure(0, weight=1)
frame2.columnconfigure(0, weight=1)

# Scrollbars for the Canvas
h_scroll = Scrollbar(frame2, orient=HORIZONTAL)
h_scroll.grid(row=1, column=0, sticky="ew")

v_scroll = Scrollbar(frame2, orient=VERTICAL)
v_scroll.grid(row=0, column=1, sticky="ns")

# Making a Canvas
canvas = Canvas(frame2, bg="white", xscrollcommand=h_scroll.set, yscrollcommand=v_scroll.set)
canvas.grid(row=0, column=0, sticky="nsew")
canvas.config(cursor="pencil")

h_scroll.config(command=canvas.xview)
v_scroll.config(command=canvas.yview)

# For Windows and MacOS
canvas.bind_all("<MouseWheel>", _on_mouse_wheel)

# Configure root to expand and fill the canvas frame
root.rowconfigure(1, weight=1)
root.columnconfigure(0, weight=1)

########### Main Loop ###########

root.mainloop()
