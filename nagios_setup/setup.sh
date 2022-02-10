#!/bin/bash

#This script is used to setup Nagios Ansible & docker server

set +x

echo "************ Launching Instances by terraform script *****************" 

terraform apply -auto-approve

a=$(aws ec2 describe-instances   --filter "Name=instance-state-name,Values=running"   --query "Reservations[*].Instances[*].[PublicIpAddress, Tags[?Key=='Name'].Value|[0]]"   --output text | grep Ansible-server | awk '{print $1}')


b=$(aws ec2 describe-instances   --filter "Name=instance-state-name,Values=running"   --query "Reservations[*].Instances[*].[PublicIpAddress, Tags[?Key=='Name'].Value|[0]]"   --output text | grep Mysql-server | awk '{print $1}')


c=$(aws ec2 describe-instances   --filter "Name=instance-state-name,Values=running"   --query "Reservations[*].Instances[*].[PublicIpAddress, Tags[?Key=='Name'].Value|[0]]"   --output text | grep Nagios-server | awk '{print $1}')

sleep 10s

echo "Ansible-server=$a Mysql-server=$b Nagios-server=$c"

echo "************* Installing Ansible, docker & launch mysql container  ************"

sed -i s#"node01"#"$b"#g /root/ansible.sh

scp -o StrictHostKeyChecking=no -i bantu.pem bantu.pem nagios_server.yml docker.yml  ec2-user@$a:/home/ec2-user/

ssh -i bantu.pem ec2-user@$a "bash -s" < ansible.sh

echo "************* Installing Nagios server ************"

sed -i s#"mysql"#"nagios"#g /root/ansible.sh

sed -i s#"$b"#"$c"#g /root/ansible.sh

sed -i s#"docker.yml"#"nagios_server.yml"#g /root/ansible.sh                                               

sed -i '/^ssh-keygen/ s/./#&/' /root/ansible.sh

ssh -i bantu.pem ec2-user@$a "bash -s" < ansible.sh

echo "************* Installing NRPE on docker server ************"

sed -i s#"nagios-server"#"$c"#g /root/nagios_client.yml

scp -o StrictHostKeyChecking=no -i bantu.pem nagios_client.yml ec2-user@$a:/home/ec2-user/


ssh -tt -i bantu.pem ec2-user@$a <<EOF

sudo -i

ansible-playbook /home/ec2-user/nagios_client.yml

exit
exit
EOF

echo "************* Adding Host on Nagios server for monitoring of docker server ************"

sed -i s#"service_def"#"$b"#g /root/nagios_hosts.yml

scp -o StrictHostKeyChecking=no -i bantu.pem nagios_hosts.yml host_template.cfg ec2-user@$a:/home/ec2-user/

ssh -tt -i bantu.pem ec2-user@$a <<EOF

sudo -i

ansible-playbook /home/ec2-user/nagios_hosts.yml


exit
exit
EOF

echo "****************Task Finished*****************"


echo "***************Script Restoration started*************"

sleep 2s

sed -i s#"$c"#"node01"#g /root/ansible.sh

sed -i s#"nagios_server.yml"#"docker.yml"#g /root/ansible.sh                                               

sed -i s#"nagios"#"mysql"#g /root/ansible.sh

sed -i s#"$c"#"nagios-server"#g /root/nagios_client.yml

sed -i s#"$b"#"service_def"#g /root/nagios_hosts.yml

sed  -i '/#ssh-keygen/ s/.//' /root/ansible.sh

echo "***************Script Restoration done*************"


echo "***************All done! Thankyou!*************"
