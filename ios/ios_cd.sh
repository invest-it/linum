#!/bin/bash

cd ./ios

gem install bundler:1.17.2
bundle install

export GIT_BASIC_AUTH_TOKEN=$(echo -n "$GIT_USER_NAME:$GIT_ACCESS_TOKEN" | base64 | tr -d \\n)
openssl aes-256-cbc -d -in .encrypted -k $AUTH_KEY_ENCRYPTION_KEY >> ./AuthKey.p8

cd ../
flutter build ios --release --no-codesign

export GIT_TERMINAL_PROMPT=1

cd ./ios
bundle exec fastlane beta