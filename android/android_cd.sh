#!/bin/bash

cd ./android

gem install bundler:1.17.2
bundle install

echo $(echo "$UPLOAD_KEYSTORE_JKS" | base64 --decode) > ./app/upload_key.jks
echo $(echo "$KEY_PROPERTIES" | base64 --decode) > key.properties

cd ../
flutter build appbundle

cd ./android
bundle exec fastlane beta