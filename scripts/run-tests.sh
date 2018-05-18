#!/bin/bash
set -ev
if [[ "$SEXY_SETTINGS" =~ .*headless_chrome.* ]]
then
    wget https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    sudo cp chromedriver /usr/local/bin/chromedriver
fi
if [[ "$SEXY_SETTINGS" =~ .*webkit.* ]]
then
    sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
    export DISPLAY=:99.0
    sh -e /etc/init.d/xvfb start &
    sleep 3
fi
bundle exec rake rubocop features:smoke
shopt -s nocasematch;
if [[ "$SEXY_SETTINGS" == "" || "$SEXY_SETTINGS" =~ .*phantomjs|poltergeist|headless_chrome|webkit.* ]]
then
	bundle exec rake features:bvt features:p1 features:p2
fi
