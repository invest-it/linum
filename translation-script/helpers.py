import json


def add_entries_to_json(entries: dict, file_path: str):
    with open(file_path, 'r+', encoding='utf-8') as src_file:
        data: dict = json.load(src_file)
        src_file.truncate(0)

    for k, v in entries.items():
        data[k] = v

    with open(file_path, 'w', encoding='utf-8') as dest_file:
        json.dump(data, dest_file, indent=4, sort_keys=True, ensure_ascii=False)

    # TODO: Add success info


def continue_translating() -> bool:
    user_input = input("Continue translating? (yes/no): ")
    if user_input.upper() == "NO" or user_input.upper() == "N":
        print("Exiting without translating..")
        return False

    if user_input.upper() == "YES" or user_input.upper() == "Y":
        print("Continuing..")
        return True

    else:
        print("Please enter yes or no.")
        return continue_translating()
