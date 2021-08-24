#!/bin/bash
set -ev
if [[ "$SEXY_SETTINGS" =~ .*headless_firefox.* ]]
then
    wget https://github.com/mozilla/geckodriver/releases/download/v0.25.0/geckodriver-v0.25.0-linux64.tar.gz
    mkdir geckodriver
    tar -xzf geckodriver-v0.25.0-linux64.tar.gz -C geckodriver
    export PATH=$PATH:$PWD/geckodriver
    sleep 3
fi
if [[ "$SEXY_SETTINGS" =~ .*headless_chrome.* ]]
then
    wget https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    sudo cp chromedriver /usr/local/bin/chromedriver
    sleep 3
fi
bundle exec rake rubocop features:smoke
shopt -s nocasematch;
if [[ "$SEXY_SETTINGS" == "" || "$SEXY_SETTINGS" =~ .*headless_chrome|headless_firefox.* ]]
then
	bundle exec rake features:bvt features:p1 features:p2
fi
