## Role Info 
>Ansible role to install Nagios Server on Centos 7


## Tested on Centos7

## Tasks in the role 
The role contains tasks to:

- Installed basic required packages
- Download Nagios and install
```
$ vim nagios.yml
---
- name: Installation of nagios
  hosts: all
  user: root

  tasks:

  - name: install epel-release
    command: amazon-linux-extras install epel -y

  - name: install httpd
    command: yum install httpd* -y

  - name: Install the prerequisite packages
    yum: name={{item}} state=installed
    with_items:
    - gcc
    - glibc
    - glibc-common
    - wget
    - unzip
    - httpd
    - php
    - gd
    - make
    - gd-devel
    - perl
    - postfix

  - name: Download nagios-4
    get_url:
      url: https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz
      dest: /root/

  - name: Extract nagioscore-nagios-4.4.5.tar.gz into /root/
    ansible.builtin.unarchive:
      src: /root/nagioscore-nagios-4.4.5.tar.gz
      dest: /root/
      remote_src: yes
  - name: Compile nagios with Confiure command
    command: chdir=/root/nagioscore-nagios-4.4.5 ./configure

  - name: Compile nagios with Make all command
    command: chdir=/root/nagioscore-nagios-4.4.5 make all

  - name: Create nagios User and Group
    command: chdir=/root/nagioscore-nagios-4.4.5 make install-groups-users

  - name: Add apache user to the Nagios groups
    command: usermod -a -G nagios apache

  - name: Install Nagios Binaries, HTML and CGIs files
    command: chdir=/root/nagioscore-nagios-4.4.5 make install

  - name: Install Daemon
    command: chdir=/root/nagioscore-nagios-4.4.5 make install-daemoninit

  - name: Install Command Mode
    command: chdir=/root/nagioscore-nagios-4.4.5 make install-commandmode

  - name: Install sample config file
    command: chdir=/root/nagioscore-nagios-4.4.5 make install-config

  - name: Install Apache Config Files
    command: chdir=/root/nagioscore-nagios-4.4.5 make install-webconf

  - name: Prerequisites to install Nagios-Plugins
    command: yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils

  - name: Create Nagios Web login user
    command: htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios@123
 
  - name: Installing nagios plugins
    command: yum install nagios-plugins-all nagios-plugins-nrpe -y
   
  - name: Plugins path change
    command: sed -i s#"/usr/local/nagios/libexec"#"/usr/local/nagios/plugins"#g /usr/local/nagios/etc/resource.cfg
  
  - name: nrpe command defination
    blockinfile:
      state: present
      insertafter: EOF
      dest: /usr/local/nagios/etc/objects/commands.cfg
      content: |
        define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -u -c $ARG1$
        }
  - name: Restart httpd
    service:
      name: httpd
      state: restarted

  - name: Restart nagios
    service:
      name: nagios
      state: restarted
```
## Running playbook 
```
ansible-playbook nagios.yml
