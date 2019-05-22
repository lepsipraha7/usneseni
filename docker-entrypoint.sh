#!/bin/sh

timestamp=$(date +%s)
REPO="https://$GITHUB_KEY@github.com/lepsipraha7/usneseni.git"
git config --global user.email "bot@lepsipraha7.cz"
git config --global user.name "LepsiPraha7 import bot"

#git clone --depth 1 --single-branch --branch source https://github.com/lepsipraha7/usneseni.git /source &&
cd /source &&
echo "Fetching from github.com..." &&
git pull origin source &&
cd .. &&
echo "Fetching from praha7.cz..." &&
./fetcher.rb &&
echo "Pushing to github.com..." &&
cd /source &&
git diff --quiet && git diff --staged --quiet || (git commit -am 'Auto imported new data' && git push $REPO source)
