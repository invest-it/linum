<b>Installation</b>

(Install Python 3 first, if not already installed)

To install the required packages run <code>pip install -r requirements.txt</code>.


Before running the script you need to add the *translator-config.json* to the same directory as the _translate.py_ file. There you have to add following json: <br>
```yaml
{
   "auth_key": "YOUR_PERSONAL_DEEPL_AUTH_KEY",
    "lang": {
        "EN-GB": "en.json",
        "ES": "es.json",
        "FR": "f.json",
        "NL": "nl.json"

        # Base structure, remove when copying:
        "LANGUAGE_KEY": "LANGUAGE_FILE RELATIVE TO LANGUAGE_BASE_DIR" 
        
    }
}
```
Don't specify the file and language you want to translate.<br> 
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
<code>python translate.py <br>
-d LANGUAGE_FILE_DIR <br>
-b LANGUAGE_FILE_TO_TRANSLATE <br>
-c LANGUAGE_FILE_TO_COMPARE_AGAINST
</code> <br>
to run the script.

From the <code>translation-script</code> directory this resolves to: <br>
<code>python translate.py -d ../lang -b de.json -c en.json</code>

The missing language-tags will now be added to the other files.
<br>
<br>


<b>VS Code</b>

To launch the script with one click add following lines to your <code>launch.json</code>: 
```yaml
"configurations": [
        {
            "name": "Translate",
            "type": "python",

            "request": "launch",
            "program": "translate.py",
            "args": [
                "-d",
                "../lang",
                "-b",
                "de.json",
                "-c",
                "en.json"
            ],
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}\\translation-script",
            "justMyCode": true
        },
    ]
```

(via _Run -> Add Configuration_)
<br>
You should now be able to simply run the script from _Run and Debug Window (Ctrl + Shift + D)_
<br>
<br>

<b>Android Studio</b>

Add new Configuration via _Run -> Edit Configurations... -> + -> Shell Script_
Select _Script text_ as execution mode and add <code>python translate.py -d ../lang -b de.json -c en.json</code> <br>
Set the working directory to the scripts base directory _translation-script_
<br>
<br>

Have fun translating! :)
