import json
from typing import Tuple

from flatten import flatten_dict

def deleted_entries(dict1: dict[str, str], dict2:  dict[str, str]) -> list[str]:
    deleted = []
    for key, value in dict2.items():
        value_dict_1 = dict1.get(key)
        if value_dict_1 is None:
            deleted.append(key)
    return deleted

def compare_flattened(dict1: dict[str, str], dict2:  dict[str, str]) -> dict[str, str]:
    differences = {}
    for key, value in dict1.items():
        value_dict_2 = dict2.get(key)
        if value_dict_2 is None:
            differences[key] = value
        elif value_dict_2 != value:
            differences[key] = value
    return differences

def compare_files(file1, file2) -> Tuple[dict[str, str], list[str]]:
    with open(file1, encoding='utf-8') as base_file:
        b_data: dict = json.load(base_file)

    with open(file2, encoding='utf-8') as comparision_file:
        c_data: dict = json.load(comparision_file)
    
    c_flattened = flatten_dict(c_data)
    b_flattened = flatten_dict(b_data)

    print(c_flattened)
    print(b_flattened)

    diffs = compare_flattened(b_flattened, c_flattened)
    deleted = deleted_entries(b_flattened, c_flattened)

    return (diffs, deleted)


# print(get_new_entries('de.json', 'en.json'))
