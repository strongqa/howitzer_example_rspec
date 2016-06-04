howitzer_example_rspec
=======================

# Howitzer
[![Build Status](https://travis-ci.org/strongqa/howitzer_example_rspec.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/strongqa/howitzer_example_rspec.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/strongqa/howitzer_example_rspec/badges/gpa.svg)][codeclimate]


[travis]: https://travis-ci.org/strongqa/howitzer_example_rspec
[gemnasium]: https://gemnasium.com/strongqa/howitzer_example_rspec
[codeclimate]: https://codeclimate.com/github/strongqa/howitzer_example_rspec

Howitzer example project based on Turnip for demo web application http://demoapp.strongqa.com

## Requirements
Ruby 2+
Howitzer 2+

## Getting Started

  git clone -b new_dsl --recursive git@github.com:strongqa/howitzer_example_rspec.git  

or specific branch

```bash
git clone -b <branch> --recursive git@github.com:strongqa/howitzer_example_rspec.git  
bundle install
rake -T
```  

##  Contributing

This repo uses sub modules

If you need to change something in any submodule(for example ./emails), please follow following instructions:

```bash
git checkout -b some_branch_name
cd ./emails
git checkout master
git pull origin master
git checkout -b some_branch_name
#modify some files
git add .
git commit -m 'some text about a change'
git push origin some_branch_name
#create Pull request on GitHub
cd ../
git add .
git commit -am 'updated emails submodule'
git push origin some_branch_name
#create Pull request on GitHub with link to previous Pull Request and wait until code will be reviewed
#Merge Pull Request for submodule first
cd ./emails
git checkout master
git pull origin master
cd ..
git add .
git commit -am 'updated emails submodule'
git push origin some_branch_name
#Merge Pull Request for main repo
```
