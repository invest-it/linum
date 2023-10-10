#!/bin/bash

cd ./ios || exit

gem install bundler:1.17.2
bundle install

GIT_BASIC_AUTH_TOKEN=$(echo -n "$GIT_USER_NAME:$GIT_ACCESS_TOKEN" | base64 | tr -d \\n)
export GIT_BASIC_AUTH_TOKEN

gcloud secrets versions access latest --secret=linum-ios-auth-file --project=658687609050 > ./AuthKey.p8

flutter build ios --release --no-codesign

export GIT_TERMINAL_PROMPT=1

cd ./ios || exit

if [ "$1" = "release" ]
then
  bundle exec fastlane release
else
  bundle exec fastlane beta
fi
