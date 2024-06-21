from PIL import Image

# Ön izleme resminin dosya yolu
preview_path = r"D:\testattributes\80321004007.SLDPRT\preview.bmp"

# Ön izleme resmini yükle
preview_image = Image.open(preview_path)

# Ön izleme resmini görüntüle
preview_image.show()
