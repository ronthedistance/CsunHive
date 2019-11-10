#!/bin/bash
${cat /etc/*release}

#this enables the firewall
sudo ufw enable

#prevent the use of guest logins via LightDM user management
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf

#edits password configu files , 90 days maximum, 10 days minimum, with a login warning of 1 week
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

#finds media files with these suffixes and removes them
for suffix in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat sh
do
  sudo find /home -name *.$suffix
done

#removes what are typically referred to as hacking tools within the competition
sudo apt-get -y nmap
sudo apt-get -y wireshark
sudo apt-get -y zenmap
sudo apt-get -y nikto 
sudo apt-get -y purge hydra*
sudo apt-get -y purge john*
sudo apt-get -y purge nikto*
sudo apt-get -y purge netcat*
sudo apt-get -y purge ophcrack*
