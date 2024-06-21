import os
import win32com.client

def get_file_properties(file_path):
    properties = {}
    try:
        shell = win32com.client.Dispatch("Shell.Application")
        namespace = shell.NameSpace(os.path.dirname(file_path))
        item = namespace.ParseName(os.path.basename(file_path))
        
        # Get the attribute value with sequence number 388
        attribute_value = namespace.GetDetailsOf(item, 388)
        properties[file_path] = attribute_value
        
    except Exception as e:
        print(f"An error occurred while getting properties of '{file_path}': {e}")
    
    return properties

def print_attributes_with_sequence_number_388(folder_path):
    if os.path.exists(folder_path) and os.path.isdir(folder_path):
        print(f"Attributes with sequence number 388 in folder: {folder_path}")
        print("-" * 50)
        for filename in os.listdir(folder_path):
            file_path = os.path.join(folder_path, filename)
            if os.path.isfile(file_path):
                file_properties = get_file_properties(file_path)
                if file_properties:
                    for file_path, attribute_value in file_properties.items():
                        print(f"File: {file_path}")
                        print(f"Attribute with sequence number 388: {attribute_value}")
                        print("-" * 50)
                else:
                    print(f"No attributes with sequence number 388 found for file: {file_path}")
                    print("-" * 50)
    else:
        print(f"The folder '{folder_path}' does not exist or is not a valid directory.")

# Main function
def main():
    folder_path = r"E:\DATALAR\86-MRCR_MERCURY_AMERIKA_8565-3\5704"
    print_attributes_with_sequence_number_388(folder_path)

if __name__ == "__main__":
    main()
