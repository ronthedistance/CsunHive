#!/bin/bash
#Tells you the version number. If it's not the latest version, you may get points for upgrading this.
${cat /etc/*release}

#unalias all commands
unalias -a

#gets rid of root users
	printf "\nChecking for 0 UID users...\n"
	#--------- Check and Change UID's of 0 not Owned by Root ----------------
	touch /zerouidusers
	touch /uidusers

	cut -d: -f1,3 /etc/passwd | egrep ':0$' | cut -d: -f1 | grep -v root > /zerouidusers

	if [ -s /zerouidusers ]
	then
		echo "There are Zero UID Users! I'm fixing it now!"

		while IFS='' read -r line || [[ -n "$line" ]]; do
			thing=1
			while true; do
				rand=$(( ( RANDOM % 999 ) + 1000))
				cut -d: -f1,3 /etc/passwd | egrep ":$rand$" | cut -d: -f1 > /uidusers
				if [ -s /uidusers ]
				then
					echo "Couldn't find unused UID. Trying Again... "
				else
					break
				fi
			done
			usermod -u $rand -g $rand -o $line
			touch /tmp/oldstring
			old=$(grep "$line" /etc/passwd)
			echo $old > /tmp/oldstring
			sed -i "s~0:0~$rand:$rand~" /tmp/oldstring
			new=$(cat /tmp/oldstring)
			sed -i "s~$old~$new~" /etc/passwd
			echo "ZeroUID User: $line"
			echo "Assigned UID: $rand"
		done < "/zerouidusers"
		update-passwd
		cut -d: -f1,3 /etc/passwd | egrep ':0$' | cut -d: -f1 | grep -v root > /zerouidusers

		if [ -s /zerouidusers ]
		then
			echo "WARNING: UID CHANGE UNSUCCESSFUL!"
		else
			echo "Successfully Changed Zero UIDs!"
		fi
	else
		echo "No Zero UID Users"
	fi

	
#this enables the firewall
sudo ufw enable

#prevent the use of guest logins via LightDM user management
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf

#edits password configuration files , 90 days maximum, 10 days minimum, with a login warning of 1 week
sudo sed -i '/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS   90' /etc/login.defs
sudo sed -i '/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   10'  /etc/login.defs
sudo sed -i '/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7' /etc/login.defs

#Asks if you want to install vsftpd and configure it. Else: removes it.
echo -n "VSFTP [Y/n] "
read option
if [[ $option =~ ^[Yy]$ ]]
then
  sudo apt-get -y install vsftpd
  # Disable anonymous uploads
  sudo sed -i '/^anon_upload_enable/ c\anon_upload_enable no' /etc/vsftpd.conf
  sudo sed -i '/^anonymous_enable/ c\anonymous_enable=NO' /etc/vsftpd.conf
  # FTP user directories use chroot
  sudo sed -i '/^chroot_local_user/ c\chroot_local_user=YES' /etc/vsftpd.conf
  sudo service vsftpd restart
else
  sudo apt-get -y purge vsftpd*
fi

#configure apache security
printf "\nSecuring Apache...\n"
	#--------- Securing Apache ----------------
	a2enmod userdir
	#note that this MAY cause some website downtime. Check to see if there is something important that www-data needs to access in order to keep apache running well.
	chown -R root:root /etc/apache2
	chown -R root:root /etc/apache

	if [ -e /etc/apache2/apache2.conf ]; then
		echo "<Directory />" >> /etc/apache2/apache2.conf
		echo "        AllowOverride None" >> /etc/apache2/apache2.conf
		echo "        Order Deny,Allow" >> /etc/apache2/apache2.conf
		echo "        Deny from all" >> /etc/apache2/apache2.conf
		echo "</Directory>" >> /etc/apache2/apache2.conf
		echo "UserDir disabled root" >> /etc/apache2/apache2.conf
	fi

	systemctl restart apache2.service

#look at suspicious files. This one looks for ELF files in common file extensions
find / -regex ".*\.\(gz\|tar\|rar\|gzip\|zip\|sh\|txt\jpg\|gif\|png\|jpeg\)" -type f -exec file -p '{}' \; | grep ELF | cut -d":" -f1
#look at suspicious files. This one looks for non-image files in image media extensions
find / -regex ".*\.\(jpg\|gif\|png\|jpeg\)" -type f -exec file -p '{}' \; | grep -v image

#finds media files with these suffixes and removes them, passes in an array
for suffix in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat sh
do
  sudo find /home -name *.$suffix
done

#removes what are typically referred to as hacking tools within the competition
sudo apt-get -y nmap*
sudo apt-get -y wireshark*
sudo apt-get -y zenmap*
sudo apt-get -y nikto* 
sudo apt-get -y purge hydra*
sudo apt-get -y purge john*
sudo apt-get -y purge nikto*
sudo apt-get -y purge netcat*
sudo apt-get -y purge ophcrack*
