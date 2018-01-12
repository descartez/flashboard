#!/bin/bash

echo '----------------------------------------------------------------------'
echo 'Welcome to Flashboard by descartez!'
echo 'This script should be run when you wish to start from a Raspberry Pi.'
echo '----------------------------------------------------------------------'

sleep 1s

echo 'bundling...'
bundle

sleep 1s

echo 'starting...'
bundle exec shotgun -o 0.0.0.0 -p 9393