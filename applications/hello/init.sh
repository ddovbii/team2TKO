#!/usr/bin/env bash

set -e  # Stop Script on Error

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

apt-get update -y

