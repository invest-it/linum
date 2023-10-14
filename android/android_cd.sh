#!/bin/bash

cd ./android || exit

KEY_PROPERTIES=$1
KEYSTORE_GPG=$2
KEYSTORE_GPG_PASS=$3


gem install bundler:1.17.2
bundle install

echo "$KEY_PROPERTIES" | base64 --decode > ./key.properties
echo "$KEYSTORE_GPG"

echo "$KEYSTORE_GPG" > ./app/upload_keystore.jks.asc

cat ./app/upload_keystore.jks.asc

gpg -d --passphrase "$KEYSTORE_GPG_PASS" --batch ./app/upload_keystore.jks.asc > ./app/upload_keystore.jks


cd ../
flutter build appbundle

cd ./android || exit
if [ "$1" = "release" ]
then
  bundle exec fastlane release
else
  bundle exec fastlane beta
fi