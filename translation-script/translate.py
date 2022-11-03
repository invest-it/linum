import argparse
import json
import os
import typing
import deepl
from compare import compare_files, compare_flattened, deleted_entries
from flatten import flatten_dict, inflate_dict
from helpers import continue_translating


def translate(
        diffs: dict[str, str],
        target_lang: str,
        source_lang: str,
        translator: deepl.Translator
) -> dict[str, str]:

    translation_dict: dict[str, str] = diffs.copy()

    if target_lang == source_lang:
        return translation_dict

    for key, value in diffs.items():
        result = translator.translate_text(value, source_lang=source_lang, target_lang=target_lang)
        translation_dict[key] = result.text  # type: ignore

        # print(k, ":", result.text)

    return translation_dict


def add_translations_to_file(
        translations: dict[str, str],
        removed_translations: list[str],
        file_path: str,
        l_code: str
):
    with open(file_path, 'r+', encoding='utf-8') as src_file:
        data: dict = json.load(src_file)
        src_file.truncate(0)

    flattened = flatten_dict(data)

    for key, value in translations.items():
        flattened[key] = value

    for removed in removed_translations:
        try:
            flattened.pop(removed)
        except KeyError:
            continue

    inflated = inflate_dict(flattened)

    with open(file_path, 'w', encoding='utf-8') as dest_file:
        json.dump(inflated, dest_file, indent=4, sort_keys=True, ensure_ascii=False)


def generate_translations():
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--dir", nargs='?', const="lang", default="lang", type=str,
                        help="directory for language files")
    parser.add_argument("-b", "--base", nargs='?', const="base.json", default="base.json", type=str,
                        help="File that is contains new tags")
    parser.add_argument("-c", "--compare", nargs='?', const="de-DE.json", default="de-DE.json", type=str,
                        help="File the base file gets compared to")
    parser.add_argument("-s", "--single", nargs='?', const=False, default=False, type=bool,
                        help="Only update the compared file")

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

        diffs, deleted = compare_files(full_base_path, full_compare_path)

        diffs_len = len(diffs)

        if len(diffs) == 0 and len(deleted) == 0:
            print("Not enough changed tags to translate. Exiting..")
            exit()
        print("Found the following changed tag(s): \n", diffs)

        if continue_translating():
            for key, value in output_config.items():
                output_file = os.path.join(args.dir, value)

                if not os.path.exists(output_file):
                    print(f"Configured output file '{output_file}' does not exist. "
                          f"Please check for typos in translator-config.json!")
                    # TODO: Create?
                    print("Exiting..")
                    exit()

                if args.single:
                    if value == args.compare:
                        translations = translate(diffs, key, "DE", translator)
                        add_translations_to_file(translations, deleted, output_file, key)
                        break

                translations = translate(diffs, key, "DE", translator)
                add_translations_to_file(translations, deleted, output_file, key)

            print("Translations for tag(s): \n", diffs)
            print(f"Successfully translated {diffs_len} tag(s). Deleted {len(deleted)} tag(s). Exiting now..")
    else:
        print("Not enough arguments specified! Type --help or -h for more information.")


generate_translations()
