#!/bin/bash
command_exists () {
  command "$1" &> /dev/null ;
}


echo '------------------------------------------------------------------'
echo 'Welcome to Flashboard by descartez!'
echo 'This script should be run once, at the setup of the device.'
echo '------------------------------------------------------------------'

sleep 1s

echo 'Checking if Ruby is installed'

if command_exists rbenv
then
  echo 'rbenv found, no action needed'
elif command_exists rvm
then
  echo 'rvm found, no action needed'
else
  echo 'Did not find rbenv or rvm!'
  echo 'Please install either tool to manage ruby'
  echo 'rbenv: `brew install rbenv ruby-build`'
  echo 'rvm: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`'
  exit 1
fi

sleep 1s

echo 'Checking if bundler is installed'
if command_exists bundle
then
  echo 'bundle found, no action needed'
else
  echo 'Did not find bundler!'
  echo 'to install: `gem install bundler`'
fi


