from PIL import Image


# Get file name
def get_file_name(file_path:str) -> str:
    if "\\" in file_path:
        return file_path.split("\\")[-1]
    elif "/" in file_path:
        return file_path.split("/")[-1]
    else:
        raise Exception("Not a valid file path")
    

def get_rgba_image(path):
    return Image.open(path).convert("RGBA")