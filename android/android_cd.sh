#!/bin/bash

cd ./android || exit

gem install bundler:1.17.2
bundle install

echo $(echo "$KEY_PROPERTIES" | base64 --decode) > key.properties

gcloud secrets versions access latest --secret=linum-android-release-keystore-file --project=658687609050 > upload_keystore.jks
cd ../
flutter build appbundle

cd ./android || exit
if [ "$1" = "release" ]
then
  bundle exec fastlane release
else
  bundle exec fastlane beta
fi