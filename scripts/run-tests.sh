#!/bin/bash
set -ev
if [[ "$SEXY_SETTINGS" =~ .*headless_chrome.* ]]
then
    wget https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    sudo cp chromedriver /usr/local/bin/chromedriver
    sleep 3
fi
if [[ "$SEXY_SETTINGS" =~ .*webkit.* ]]
then
    export DISPLAY=:99.0
    sh -e /etc/init.d/xvfb start &
    sleep 3
fi
bundle exec rake rubocop features:smoke
shopt -s nocasematch;
if [[ "$SEXY_SETTINGS" == "" || "$SEXY_SETTINGS" =~ .*poltergeist|headless_chrome|webkit.* ]]
then
	bundle exec rake features:bvt features:p1 features:p2
fi
