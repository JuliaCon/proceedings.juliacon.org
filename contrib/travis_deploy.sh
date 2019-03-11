#!/bin/bash
DIR=`dirname $0`
mkdir ~/.ssh
base64 -d <<< "${DEPLOY_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
chmod 700 ~/.ssh
$DIR/../deploy.sh
