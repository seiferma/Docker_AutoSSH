#!/bin/sh

# Required files (provide via volumes):
#   /home/autossh/.ssh/secret.key
#   /home/autossh/.ssh/known_hosts
# Used environment variables:
#   LOCAL_FORWARDINGS   comma separated list of local forwarding strings
#   SSH_USER            username to be used to connect via SSH
#   SSH_HOST            hostname to be used to connect via SSH
#   SSH_PORT            port to be used to connect via SSH

if [ -z "$SSH_USER" ]; then
        echo "SSH_USER has to be set."
        exit 1
fi
if [ -z "$SSH_HOST" ]; then
        echo "SSH_HOST has to be set."
        exit 1
fi
PORT_TO_USE=22
if [ ! -z "$SSH_PORT" ]; then
        PORT_TO_USE=$SSH_PORT
fi
if [ ! -f /home/autossh/.ssh/secret.key ]; then
        echo "file /home/autossh/.ssh/secret.key has to exist"
        exit 1
fi
if [ ! -f /home/autossh/.ssh/known_hosts ]; then
        echo "file /home/autossh/.ssh/known_hosts has to exist"
        exit 1
fi

FORWARDINGS=""
if [ ! -z "$LOCAL_FORWARDINGS" ]; then
        FORWARDINGS=$FORWARDINGS" -L $(echo $LOCAL_FORWARDINGS | sed 's/,/ -L /g')"
fi

exec autossh -4 -M 0 -o "ExitOnForwardFailure=yes" -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -N $FORWARDINGS -p $PORT_TO_USE $SSH_USER@$SSH_HOST -i /home/autossh/.ssh/secret.key

