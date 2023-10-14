#!/bin/bash

cd ./android || exit

# Generating KEY_PROPERTIES
# base64 -i ./key.properties
# Store in Secrets
KEY_PROPERTIES=$1

# Generating the KEYSTORE_GPG
# gpg -c --armor upload_keystore.jks
# base64 -i upload_keystore.jks.asc
# Store output in secrets
KEYSTORE_GPG=$2

# The pass used for gpg
# Store in secrets
KEYSTORE_GPG_PASS=$3


gem install bundler:1.17.2
bundle install



echo "$KEY_PROPERTIES" | base64 --decode > ./key.properties
echo "$KEYSTORE_GPG"

echo "$KEYSTORE_GPG" | base64 --decode > ./app/upload_keystore.jks.asc

cat ./app/upload_keystore.jks.asc

gpg -d --passphrase "$KEYSTORE_GPG_PASS" --batch ./app/upload_keystore.jks.asc > ./app/upload_keystore.jks


cd ../
flutter build appbundle

cd ./android || exit
if [ "$4" = "release" ]
then
  bundle exec fastlane release
else
  bundle exec fastlane beta
fi