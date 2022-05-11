import json

def get_new_entries(template_file_path, compared_file_path):
    with open(template_file_path, encoding='utf-8') as src_file:
        t_data: dict = json.load(src_file)

    with open(compared_file_path, encoding='utf-8') as src_file:
        data: dict = json.load(src_file)

    new_entries: dict = {}

    for k, v in t_data.items():
        if data.get(k) is None:
            new_entries[k] = v

    return new_entries


# print(get_new_entries('de.json', 'en.json'))
