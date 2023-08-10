#!/bin/bash
sed -i 's/^.*PasswordAuthentication yes.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^.*PasswordAuthentication no.*$/PasswordAuthentication no/' /etc/ssh/sshd_config