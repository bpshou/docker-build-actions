#!/bin/bash


set -e

# first arg is `-f` or `--some-option`
if [ "$1" = "sshd" ]; then
    # run ttyd service
    nohup ttyd -p 8686 -c root:origin123456 bash > /dev/null 2>&1 &
fi

exec "$@"
