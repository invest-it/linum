<b>Installation</b>

Before running the script you need to add the *translator-config.json* to the same directory as the _README.md_ file. There you have to add following json: <br>
```yaml
{
   "auth_key": "YOUR_PERSONAL_DEEPL_AUTH_KEY",
    "lang": {
        "DE": "de-DE.json"
        "EN-GB": "en-US.json",
        "ES": "es-ES.json",
        "FR": "fr-FR.json",
        "NL": "nl-NL.json"

        # Base structure, remove when copying:
        "LANGUAGE_KEY": "LANGUAGE_FILE RELATIVE TO LANGUAGE_BASE_DIR" 
    }
}
```
Language keys must be supported by the DeepL API:

[DeepL API Request Parameters](https://www.deepl.com/de/docs-api/translating-text/request/)

If you don't have an <code>auth_key</code> create an DeepL-Account first:

[DeepL API](https://www.deepl.com/de/docs-api/)
<br>
<br>


<b>Use the script</b>

Add a new tag to the specified base language file (file to be translated) like this: <br>
```yaml
{
  "main/label-loading": "Laden...",
  
  # Base structure, remove when copying:
  "KEY": "TEXT",
}
```

Then open a console and type <br> 
<code>dart run bin/translation_script.dart<br>
-d LANGUAGE_FILE_DIR <br>
-b LANGUAGE_BASE_FILE <br>
-c LANGUAGE_FILE_TO_COMPARE_AGAINST
</code> <br>
to run the script.

From the <code>translation-script</code> directory this resolves to: <br>
<code>dart run bin/translation_script.dart -d ../lang -b base.json -c de-DE.json</code>

The missing language-tags will now be added to the other files.
<br>
<br>
**IMPORTANT:** The base file and the file you compare against, should always be of the same language - otherwise all 
keys will be marked as changed!


<b>VS Code</b>

To launch the script with one click add following lines to your <code>launch.json</code> (via _Run -> Add Configuration_): 

```yaml
"configurations": [
        {
            "name": "Translate",
            "type": "dart",

            "request": "launch",
            "program": "bin/translation_script.dart",
            "args": [
                "-d",
                "../lang",
                "-b",
                "base.json",
                "-c",
                "de-DE.json"
            ],
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}\\translation-script",
            "justMyCode": true
        },
    ]
```


<b>Android Studio</b>

Add new Configuration via _Run -> Edit Configurations... -> + -> Shell Script_
Select _Script text_ as execution mode and add <code>dart run bin/translation_script.dart -d ../lang -b base.json -c de-DE.json</code> <br>
Set the working directory to the scripts base directory _translation-script_
<br>
<br>

Have fun translating! :)
