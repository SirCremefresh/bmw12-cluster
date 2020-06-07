#!/usr/bin/env bash
# start secrets file and pass all parameters
node "$(dirname $(readlink -f $0))/bin/secrets.js" "$@"
