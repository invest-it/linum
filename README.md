# linum

[![CI Core Checks](https://github.com/invest-it/linum/actions/workflows/ci-core.yaml/badge.svg)](https://github.com/invest-it/linum/actions/workflows/ci-core.yaml)
[![CI Checks](https://github.com/invest-it/linum/actions/workflows/ci-ext.yaml/badge.svg)](https://github.com/invest-it/linum/actions/workflows/ci-ext.yaml)

Get your money under control before your money has you under control.
This budget tracker is designed to teach young people how to keep track of spendings and how to budget effectively.

## Setup (for intern Developers)

Follow
[this](https://docs.flutter.dev/get-started/install)
tutorial to setup flutter on your machine.

Before running the application for the first time you'll need to generate the *firebase_options.dart* file.

To do this you'll need to install **firebase-tools**: <br>
With npm: <br> `npm install -g firebase-tools`

With brew (MacOS): <br> `brew install firebase-cli`

Afterwards run: <br>
`firebase login` <br>

A login screen will appear, please register with your InvestIt Account. <br>

Then run: <br>
```shell
dart pub global activate flutterfire_cli
``` 
and <br>
```shell
flutterfire configure -o lib/firebase/firebase_options.g.dart -p linum-dev -y --platforms="android,ios"
```
alternatively use the _get-firebase-options.sh_ or _get-firebase-options.bat_

Now you can start the application with `flutter run`

For everything else, please turn to our [wiki](https://github.com/invest-it/linum/wiki).