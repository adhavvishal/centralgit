#!/bin/bash

set -x

# This script is used to install ansible server.

sudo -i

amazon-linux-extras install epel -y


yum install htop ansible -y

echo "" >> /etc/ansible/hosts

echo "[mysql]" >> /etc/ansible/hosts

echo "" >> /etc/ansible/hosts

echo "node01" >> /etc/ansible/hosts

cp /home/ec2-user/bantu.pem /root/

ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P "" 

scp -o StrictHostKeyChecking=no -i bantu.pem /root/.ssh/id_rsa.pub ec2-user@node01:/home/ec2-user/


ssh -tt -i bantu.pem ec2-user@node01 <<EOF

sudo -i

yum install htop -y

echo "" >> /root/.ssh/authorized_keys

cat /home/ec2-user/id_rsa.pub >> /root/.ssh/authorized_keys

exit
exit
EOF

ansible-playbook /home/ec2-user/docker.yml

