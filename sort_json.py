import json
import sys

filename = sys.argv[1]
if filename == "" or None:
   exit()

with open(filename, 'r', encoding='utf-8') as f:
  data = json.load(f)


with open(filename, "w", encoding='utf-8') as jsonFile:
    json.dump(data, jsonFile, sort_keys=True, ensure_ascii=False, indent=4)