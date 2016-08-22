#!/bin/bash
set -ev
bundle exec rake features:smoke
shopt -s nocasematch;
