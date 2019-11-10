#!/bin/bash
echo "Define unecessary...."
#service --status-all
  
#/bin/systemctl | grep running
#sleep 1


while :
do
	clear
	cat<<EOF
	========================
	Service removal script
	-----------------------
	Please enter your choice:
	1: Remove a service
	2: List some necessary services
	3: List all running services
	4: Quit Script
	----------------------

EOF
	read input
	
	case "$input" in
	"1" )   echo "Please select a service to remove"
		read serviceremove
		service $serviceremove stop
		;;

	"2")	echo "Here is our base list of necessary services"		
		
		while :
		do  
		echo -e"
		===============
		Service List
		---------------
		+ acpid
		- anacron
		- apparmor
		- apport
		+ avahi-daemon
		+ bluetooth
		- brltty
		- console-setup
		+ cron **this is debatable**
		+ cups
		+ cups-browsed
		- dbus
		+ dns-clean
		+ friendly-recovery
		- grub-common
		? irqbalance
		+ kerneloops
		? killprocs
		? kmod
		? lightdm
		? networking
		? ondemand
		? ppd-dns
		- procps
		- pulseaudio
		? rc.local
		+ resolvconf
		- rsync   *i assume you're almost ALWAYS gonna deleeeeeeet this*
		+ rsyslog
		- saned
		? sendsigs *one you probably don't want to delete*
		? speech-dispatcher
		- sudo **this is up to your judgement, personally I think sudo can enabled**
		- udev
		? umountfs
		? umountnfs.nsh
		? umountroot
		- unattended-upgrades
		- urandom
		- x11-common **another one you never want to delete....*"
		read listquit 
		if [ $listquit == "quit" ]
			then
			break		
		else	
			sleep 1 
		fi
		
done
	;;   
	"3")
		echo "Listing all services"
		service --status-all
		sleep 5
	;;
	"4") echo "Goodbye"
		exit 
	;;

	*) echo invalid option
	;;
	esac 
	sleep 3
done
