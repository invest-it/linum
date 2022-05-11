import json
import sys
import os


def sort_json_file(file_path):
    with open(file_path, 'r+', encoding='utf-8') as src_file:
        data: dict = json.load(src_file)
        src_file.truncate(0)

    with open(file_path, 'w', encoding='utf-8') as dest_file:
        json.dump(data, dest_file, indent=4, sort_keys=True, ensure_ascii=False)


print(sys.argv)

if len(sys.argv) > 1:
    file_path = sys.argv[1]
    if os.path.exists(file_path):
        sort_json_file(file_path)
        print("Success")
    else:
        print("Failed, file not found!")
