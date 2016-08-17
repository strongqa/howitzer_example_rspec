#!/bin/bash
set -ev
bundle exec rake rubocop features:smoke
shopt -s nocasematch;
