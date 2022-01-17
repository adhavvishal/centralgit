#!/bin/bash

#This file install, uninstall or reinstall fsmond tool

f1="fsmon"
f2="fsmond.conf"
f3="fsmond"
f3="fsyntax"

case "$1" in
i)
	if [[ -f "/etc/init.d/$f1" ]] || [[ -f "/etc/$f2" ]] || [[ -f "/usr/bin/$f3" ]] 
	then
	    echo "fsmond is already install"
	else
	    echo "fsmond is not install"
	    cp -r fsmon /etc/init.d/
	    cp -r fsmond.conf /etc/
	    cp -r fsmond /usr/bin/
	    cp -r fsyntax /usr/bin/
	fi

        ;;
u)
	pid="$(ps -ef | grep "/usr/bin/fsmond" | egrep -v "grep" | awk '{print $2}')"	
	if ! [ -z "$pid" ]
	then
	    echo "kill daemon and remove all files"
	    kill -9 $pid
	    rm -rf /etc/init.d/fsmon /etc/fsmond.conf /etc/flag /usr/bin/fsmond /usr/bin/fsyntax /var/run/log/fsmond.log
	else
	    echo "remove all files $pid"
	    rm -rf /etc/init.d/fsmon /etc/fsmond.conf /etc/flag /usr/bin/fsmond /usr/bin/fsyntax /var/run/log/fsmond.log
	fi
        
	;;
r)
        $0 u
        $0 i
        ;;
        
*)
        echo "Usage: $0 { i = install  | r = reinstall | u = uninstall }"
esac

exit 0

