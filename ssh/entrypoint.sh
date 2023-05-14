#!/bin/bash

PS1='\e[1m\e[31m[\h] \e[32m(docker) \e[34m\u@$(hostname -i)\e[35m \w\e[0m\n$ '
echo "PS1=$PS1"
export $PS1

set -e

# first arg is `-f` or `--some-option`
if [ "$1" = "/usr/sbin/sshd" ]; then
    # run ttyd service
    nohup ttyd -p 8686 -c root:origin123456 bash > /dev/null 2>&1 &
fi

exec "$@"
