Howitzer Example Rspec
=======================

[![Build Status](https://travis-ci.org/strongqa/howitzer_example_rspec.svg?branch=master)][travis]
[![CircleCI](https://circleci.com/gh/strongqa/howitzer_example_rspec.svg?style=svg&circle-token=15ab6b1e7f4e9f9abc2e61b95e6a3cdc7d6655b7)](https://circleci.com/gh/strongqa/howitzer_example_rspec)

[travis]: https://travis-ci.org/strongqa/howitzer_example_rspec

Howitzer example project based on Rspec for demo web application http://demoapp.strongqa.com

## Requirements

- Ruby 2.2.2+
- Howitzer 2+

## Getting Started

*Note!* This project uses Git submodules in order to reuse common code between similar projects:

[howitzer_example_cucumber](https://github.com/strongqa/howitzer_example_cucumber)
[howitzer_example_turnip](https://github.com/strongqa/howitzer_example_turnip)

Typically it is not required for a regular project based on [Howitzer](https://github.com/strongqa/howitzer)

### How to try the project locally

- Clone project

```
git clone --recursive git@github.com:strongqa/howitzer_example_rspec.git
```

- Install dependencies

```
bundle install
```

- Get list of available commands

```
rake -T
```

## Contributing

Code quality is controlled by [Rubocop](https://github.com/bbatsov/rubocop)

It is useful to activate rubocop pre-commit git hook for changed files.

```
cp scripts/pre-commit .git/hooks/pre-commit
```
