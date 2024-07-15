import sys
from glob import glob
from PIL import Image


class FillDatabase:
    def __init__(self, starting, path_to_images):
        self.starting_number = starting
        self.images = glob(path_to_images)
        self.type = path_to_images.split("/")[-2].lower()
        self.is_for_kid = False
        self.is_hair_or_outfit = "hair" in path_to_images or "outfit" in path_to_images

    def load_data(self):
        print(self.type)
        if self.type == "body":
            self.fill_body()
        elif self.type == "outfit":
            self.fill_outfit()
        elif self.type == "hairstyle":
            self.fill_hairstyle()
        elif self.type == "eyes":
            self.fill_eyes()

    def print_to_terminal(self, file_path, attributes):
        file_name = self.get_file_name(file_path)
        object_name = self.get_object_name(file_name)
        object_type = self.get_object_type(file_name)
        path = file_path.replace("assets/images/", "").replace("\\", "/")
        print(f'({self.starting_number}, "{object_name}", "{object_type}", "{path}", "{attributes}", {0 if not self.is_for_kid else 1}),')

    def rgb_to_hex(self, rgb):
        r,g,b,a = rgb
        # Ensure RGB values are within the range 0 to 255
        if 0 <= r <= 255 and 0 <= g <= 255 and 0 <= b <= 255:
            return f'#{r:02x}{g:02x}{b:02x}'
        else:
            raise ValueError("RGB values must be in the range 0 to 255")

    def get_file_name(self, path_to_file):
        sep = "/"
        if "\\" in path_to_file:
            sep = "\\"
        return path_to_file.split(sep)[-1]

    def get_object_type(self, file_name):
        return file_name.split("_")[0].lower()
    
    def get_object_name(self, file_name):
        if self.is_hair_or_outfit:
            object_name = file_name.split("_")[0:2]
            object_name[1] = int(object_name[1])
            return object_name[0] + " " + str(object_name[1])
        else:
            return file_name.split("_")[0]
    
    def fill_hairstyle(self):
        point = (47, 32)
        for path in self.images:
            img = Image.open(path)
            attributes = {
                'color': self.rgb_to_hex(img.getpixel(point))
            }
            self.print_to_terminal(path, attributes)
            self.starting_number += 1

    def fill_body(self):
        point = (48, 33)
        for path in self.images:
            img = Image.open(path)
            attributes = {
                'color': self.rgb_to_hex(img.getpixel(point))
            }
            self.print_to_terminal(path, attributes)
            self.starting_number += 1

    def fill_eyes(self):
        top_point = (72, 40)
        bottom_point = (72, 42)
        for path in self.images:
            img = Image.open(path)
            attributes = {
                'top_color': self.rgb_to_hex(img.getpixel(top_point)),
                'bottom_color': self.rgb_to_hex(img.getpixel(bottom_point))
            }
            self.print_to_terminal(path, attributes)
            self.starting_number += 1

    def fill_outfit(self):
        top_point = (47, 49) # check for kid
        bottom_point = (47, 56)

        for path in self.images:
            img = Image.open(path)
            attributes = {
                'top_color': self.rgb_to_hex(img.getpixel(top_point)),
                'bottom_color': self.rgb_to_hex(img.getpixel(bottom_point))
            }
            self.print_to_terminal(path, attributes)
            self.starting_number += 1


if __name__ == "__main__":
    fill_database = FillDatabase(int(sys.argv[1]), sys.argv[2])
    fill_database.load_data()