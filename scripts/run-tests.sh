#!/bin/bash
set -ev
CUCUMBER_STATE="started"
TURNIP_STATE="started"
while [[ " ${CUCUMBER_STATE[*]} " == *"started"* ]] || [[ " ${TURNIP_STATE[*]} " == *"started"* ]]; do
        sleep 5
        CUCUMBER_STATE=$(curl -s -X GET \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       -H "Travis-API-Version: 3" \
       -H "Authorization: token ${QA_TOKEN}" \
       https://api.travis-ci.org/repo/${CUCUMBER_SLUG}/builds | grep -Po '"state":.*?[^\\]",'| awk -F "\"" '{print $4}' )
        TURNIP_STATE=$(curl -s -X GET \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       -H "Travis-API-Version: 3" \
       -H "Authorization: token ${QA_TOKEN}" \
       https://api.travis-ci.org/repo/${TURNIP_STATE}/builds | grep -Po '"state":.*?[^\\]",'| awk -F "\"" '{print $4}' )
done
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
if [[ "$SEXY_SETTINGS" =~ .*webkit.* ]]
then
    export DISPLAY=:99.0
    sh -e /etc/init.d/xvfb start &
    sleep 3
fi
bundle exec rake rubocop features:smoke
shopt -s nocasematch;
if [[ "$SEXY_SETTINGS" == "" || "$SEXY_SETTINGS" =~ .*poltergeist|headless_chrome|headless_firefox|webkit.* ]]
then
	bundle exec rake features:bvt features:p1 features:p2
fi
