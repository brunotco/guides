#!/bin/bash
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
ssh-copy-id -i $HOSTNAME