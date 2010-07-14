#!/bin/sh

KEY="$HOME/.ssh/id_dsa.pub"

if [ ! -f ~/.ssh/id_dsa.pub ];then
    echo "private key not found at $KEY"
    echo "* please create it with "ssh-keygen -t dsa" *"
    echo "* to login to the remote host without a password, don't give the key you create with ssh-keygen a password! *"
    exit
fi

if [ -z $1 ];then
    echo "Please specify user@host.tld as the first switch to this script"
    exit
fi

echo "Putting your key on $1... "

KEYCODE=`cat $KEY`
ssh -q $1 "mkdir ~/.ssh 2>/dev/null; chmod 700 ~/.ssh; echo "$KEYCODE" >> ~/.ssh/authorized_keys; chmod 644 ~/.ssh/authorized_keys"

echo "done!"
