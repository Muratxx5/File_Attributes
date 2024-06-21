import win32com.client

def open_sldprt(file_path):
    try:
        # SolidWorks uygulamasını başlat
        swApp = win32com.client.Dispatch("SldWorks.Application")
        
        # SolidWorks uygulamasını aç
        swApp.Visible = True
        
        # Yeni bir parça belgesi oluştur
        partDoc = swApp.OpenDoc6(file_path, 1, 0, "", 0, 0)
        
        # Dosyayı aç
        partDoc = swApp.OpenDoc6(file_path, 1, 0, "", 0, 0)
        
        # Dosyanın içeriğine erişmek için SolidWorks API'sini kullanabilirsiniz
        # Örneğin:
        # - Parçanın özelliklerini listeleme
        # - Montaj içindeki bileşenleri listeleme
        # - Parçanın veya montajın görünümünü oluşturma
        
        # SolidWorks uygulamasını kapat
        swApp.ExitApp()
    except Exception as e:
        print("Hata:", e)

# Örnek kullanım
file_path = r"D:\testattributes\80321004008.SLDPRT"
open_sldprt(file_path)
