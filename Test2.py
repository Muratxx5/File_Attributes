from PIL import Image

def display_thumbnail(image_path):
    try:
        # Open the image
        with Image.open(image_path) as img:
            # Display the image
            img.show()
    except IOError:
        print("Unable to load image")

# Usage: Replace "path/to/thumbnail.jpg" with the actual path of the thumbnail image file
display_thumbnail(r"E:\DATALAR\86-MRCR_MERCURY_AMERIKA_8565-3\5704\80220600038.SLDPRT")


