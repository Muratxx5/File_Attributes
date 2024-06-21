import os
import win32com.client
from datetime import datetime

def get_file_properties(file_path):
    properties = {}
    try:
        shell = win32com.client.Dispatch("Shell.Application")
        namespace = shell.NameSpace(os.path.dirname(file_path))
        item = namespace.ParseName(os.path.basename(file_path))
        
        # Mapping indices from 1 to 100
        details_mapping = {}
        for i in range(1, 901):
            attr_name = namespace.GetDetailsOf(None, i)
            if attr_name:
                details_mapping[i] = attr_name

        for index, attribute in details_mapping.items():
            attr_value = namespace.GetDetailsOf(item, index)
            if attr_value:
                properties[index] = (attribute, attr_value)
        
    except Exception as e:
        print(f"An error occurred: {e}")
    
    return properties

def print_file_attributes(file_path):
    if os.path.exists(file_path):
        # Get the creation time of the file
        creation_time = os.path.getctime(file_path)
        creation_time_formatted = datetime.fromtimestamp(creation_time).strftime('%Y-%m-%d %H:%M:%S')
        
        # Get the file size
        file_size = os.path.getsize(file_path)
        
        # Get the file properties from Windows Explorer
        properties = get_file_properties(file_path)
        
        # Print file attributes
        print(f"File: {file_path}")
        print(f"Size: {file_size} bytes")
        print(f"Creation Date: {creation_time_formatted}")
        print("Details:")
        for index, (attribute, value) in properties.items():
            print(f"  Sequence Number: {index}")
            print(f"  Attribute Name: {attribute}")
            print(f"  Attribute Value: {value}")
            print()
    else:
        print(f"The file '{file_path}' does not exist.")

# Main function
def main():
    file_path = r"E:\DATALAR\86-MRCR_MERCURY_AMERIKA_8565-3\5704\80220200101.SLDASM"
    print_file_attributes(file_path)

if __name__ == "__main__":
    main()
