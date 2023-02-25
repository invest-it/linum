import json
import sys

filename = sys.argv[1]
if filename == "" or None:
   exit()

with open(filename, 'r') as f:
  data = json.load(f)


with open(filename, "w") as jsonFile:
    json.dump(data, jsonFile, sort_keys=True, indent=4)