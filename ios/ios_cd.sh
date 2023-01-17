#!/bin/bash

cd ./ios

gem install bundler:1.17.2
bundle install

GIT_BASIC_AUTH_TOKEN=$(echo "$GIT_USER_NAME":"$GIT_ACCESS_TOKEN" | base64)
echo $(echo "$APP_STORE_AUTH_KEY" | base64 --decode) > AuthKey.p8

cd ../
flutter build ios --release --no-codesign

cd ./ios
bundle exec fastlane beta