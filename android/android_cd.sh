#!/bin/bash

cd ./android || exit

KEY_PROPERTIES=$1


gem install bundler:1.17.2
bundle install

echo "$KEY_PROPERTIES" | base64 --decode > ./key.properties

cat ./key.properties


echo $(gcloud secrets versions access latest --secret=linum-android-release-keystore-file --project=658687609050 --format "json" | jq -r .payload.data)
gcloud secrets versions access latest --secret=linum-android-release-keystore-file --project=658687609050 --format "json" | jq -r .payload.data | base64 --decode > ./app/upload_keystore.jks


cd ../
flutter build appbundle

cd ./android || exit
if [ "$1" = "release" ]
then
  bundle exec fastlane release
else
  bundle exec fastlane beta
fi