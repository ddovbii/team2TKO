#!/usr/bin/env bash

set -e  # Stop Script on Error

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

apt-get update -y

apt-get install python3 -y
apt-get install python3-pip -y

mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/artifacts.tar.gz -C $ARTIFACTS_PATH/drop/

python3 -m pip install -r $ARTIFACTS_PATH/drop/Website/requirements.txt
