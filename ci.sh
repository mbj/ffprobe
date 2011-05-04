#!/bin/bash
source ~/.profile
gem install bundler
bundle install
bundle exec rspec spec
