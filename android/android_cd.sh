#!/bin/bash

cd ./android

gem install bundler:1.17.2
bundle install

ls

openssl aes-256-cbc -d -in .encrypted -k $KEY_STORE_ENCRYPTION_KEY >> ./app/upload_keystore.jks
echo $(echo "$KEY_PROPERTIES" | base64 --decode) > key.properties

cd ../
flutter build appbundle

cd ./android
bundle exec fastlane beta