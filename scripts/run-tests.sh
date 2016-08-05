#!/bin/bash
set -ev
bundle exec rake features:smoke
shopt -s nocasematch;
if [[ "$SEXY_SETTINGS" == "" || "$SEXY_SETTINGS" =~ .*phantomjs|poltergeist.* ]]
then
	bundle exec rake features:bvt features:p1 features:p2
fi
