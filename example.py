import win32api

def change_attribute_388(file_path, new_value):
    try:
        # Set the new value for attribute 388
        win32api.SetFileAttributes(file_path, new_value)
        print(f"Changed attribute 388 of file '{file_path}' to '{new_value}'")
    
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    file_path = r"D:\testattributes\80321003995.SLDPRT"
    new_value = 388
    change_attribute_388(file_path, new_value)

if __name__ == "__main__":
    main()
