import os.path
import argparse
import json
import deepl
from compare import get_new_entries
from helpers import add_entries_to_json, continue_translating


def translate(entries: dict, output_config: dict[str, str]) -> dict[str, dict]:
    translation_dict: dict[str, dict] = {}

    for k, v in entries.items():
        for l_code in output_config.keys():
            result = translator.translate_text(v, source_lang="DE", target_lang=l_code)
            if translation_dict.get(l_code) is None:
                translation_dict[l_code] = {k: result.text}
            else:
                translation_dict[l_code][k] = result.text
            # print(k, ":", result.text)

    for l_code, file in output_config.items():
        add_entries_to_json(translation_dict[l_code], file)

    return translation_dict


parser = argparse.ArgumentParser()
parser.add_argument("-d", "--dir", help="directory for language files")
parser.add_argument("-b", "--base", help="File that is contains new tags")
parser.add_argument("-c", "--compare", help="File the base file gets compared to")

args = parser.parse_args()

if args.dir is not None and args.base is not None and args.compare is not None:
    with open('translator-config.json', 'r', encoding='utf-8') as config_file:
        config: dict = json.load(config_file)

    auth_key = config.get("auth_key")
    if auth_key is None or auth_key == "":
        print("DeepL auth key is missing, "
              "please add it to translator-config.json: \n{\n   'auth_key': 'YOUR_PERSONAL_KEY'\n}")
        exit()

    translator = deepl.Translator(auth_key)

    output_config = config.get("lang")
    if output_config is None:
        print("Output configuration is missing, "
              "please add it to translator-config.json: \n{\n   'lang': {\n     'LANG_CODE': 'FILENAME' \n    }\n}")
        exit()

    if not os.path.exists(args.dir):
        print(f"Could not find the directory specified for the language files: '{args.dir}'")
        print("Exiting..")
        exit()

    full_base_path = os.path.join(args.dir, args.base)
    if not os.path.exists(full_base_path):
        print(f"Could not find the file specified for new tags: '{full_base_path}'")
        print("Exiting..")
        exit()

    full_compare_path = os.path.join(args.dir, args.compare)
    if not os.path.exists(full_compare_path):
        print(f"Could not find the file specified for comparison: '{full_compare_path}'")
        print("Exiting..")
        exit()

    entries = get_new_entries(
        full_base_path,
        full_compare_path
    )

    entries_len = len(entries)
    if len(entries) == 0:
        print("Not enough new tags to translate. Exiting..")
        exit()
    print("Found the following new tag(s): \n", entries)

    if continue_translating():
        for key, value in output_config.items():
            output_file = os.path.join(args.dir, value)

            if not os.path.exists(output_file):
                print(f"Configured output file '{output_file}' does not exist. "
                      f"Please check for typos in translator-config.json!")
                print("Exiting..")
                exit()

            output_config[key] = output_file

        translation = translate(entries, output_config)
        print("Translations for tag(s): \n", translation)
        print(f"Successfully translated {entries_len} tag(s). Exiting now..")
else:
    print("Not enough arguments specified! Type --help or -h for more information.")


