#!/bin/bash

echo '----------------------------------------------------------------------'
echo 'Welcome to Flashboard by descartez!'
echo 'This script should be run when you wish to start from a Raspberry Pi.'
echo '----------------------------------------------------------------------'

source ~/.rvm/scripts/rvm

rvm use 2.4.1

sleep 1s
echo 'bundling...'
bundle

sleep 1s

echo 'starting...'
bundle exec shotgun -o 0.0.0.0 -p 9393