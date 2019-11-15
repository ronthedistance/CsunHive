#!/bin/bash
echo "Define unecessary...."
#Used to give a quick menu look for services and removal of services during competition. Helps keep your head on your shoulders to see your results.
#

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
	1: Stop a runnning service
	2: List some necessary services
	3: List all running services
	4: Quit Script
	----------------------
	*Note that for option 2 and 3 you will need to scroll up after inputting the number in order to see your list.
	*Note that this is meant to run on either a Debian or Ubuntu machine

EOF
	read input
	
	case "$input" in
	"1" )   echo "Please select a service to remove"
		read serviceremove
		service $serviceremove stop
		;;

	"2")	echo "Here is our base list of necessary services	
		
		cat<<EOF
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
		- rsync   *i assume you're almost ALWAYS gonna stop this one*
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
		+ means fine to run
		- means try to make sure it doesn't run or kill the service
		? means it's not managed by the "service" binary, and usually fine to keep
EOF
	;;   
	"3")
		echo "Listing all services"
		service --status-all
	;;
	"4") echo "Goodbye"
		exit 
	;;

	*) echo invalid option
	;;
	esac 
	sleep 1
done
