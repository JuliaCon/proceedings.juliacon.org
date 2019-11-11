#!/bin/bash
set -e

if ! git status > /dev/null 2>&1
then
  echo "## Initializing git repo..."
  git init
fi

REMOTE_TOKEN_URL="https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
if ! git remote | grep "origin" > /dev/null 2>&1
then 
  echo "### Adding git remote..."
  git remote add origin $REMOTE_TOKEN_URL
  echo "### git fetch..."
  git fetch
fi

git remote set-url --push origin $REMOTE_TOKEN_URL

BRANCH="$GITHUB_HEAD_REF"
echo "### Branch: $BRANCH"
git checkout $BRANCH

echo "## Login into git..."
git config --global user.email "juliacon@julialang.org"
git config --global user.name "JuliaCon Committee"


echo "### Running generator"
touch data/papers.yml

echo "## Staging changes..."
git add .
echo "## Commiting files..."
git commit -m "Update proceedings data" || true
echo "## Pushing to $BRANCH"
git push -u origin $BRANCH