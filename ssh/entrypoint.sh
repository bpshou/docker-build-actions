#!/bin/bash

# shell style
echo "export PS1='\e[1m\e[31m[\h] \e[32m(docker) \e[34m\u@$(hostname -i)\e[35m \w\e[0m\n$ '" >> .bashrc

set -e

# first arg is `/usr/sbin/sshd`
if [ "$1" = "/usr/sbin/sshd" ]; then
    # run ttyd service
    nohup ttyd -p 8686 -c root:origin123456 bash > /dev/null 2>&1 &
    # change password
    echo "root:origin123456" | chpasswd
fi

exec "$@"
