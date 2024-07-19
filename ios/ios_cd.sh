#!/bin/bash

cd ./ios || exit

gem install bundler:1.17.2
bundle install

echo "$FASTLANE_CERTS_REPO_KEY" > ./repo_key
chmod 600 ./repo_key

gcloud secrets versions access latest --secret=linum-ios-auth-key-file --project=658687609050 > ./AuthKey.p8

pod repo update
pod install

cd ../
flutter build ios --release --no-codesign

export GIT_TERMINAL_PROMPT=1

cd ./ios || exit

if [ "$1" = "release" ]
then
  MATCH_PASSWORD=${MATCH_PASSWORD} bundle exec fastlane release
else
  MATCH_PASSWORD=${MATCH_PASSWORD} bundle exec fastlane beta
fi
