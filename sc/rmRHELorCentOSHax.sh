#!/bin/bash
${cat /etc/*release}
yum remove -y nmap*
yum remove -y wireshark*
yum remove -y zenmap*
yum remove-y nikto* 
yum remove-y purge hydra*
yum remove-y purge john*
yum remove-y purge nikto*
yum remove -y purge netcat*
yum remove -y purge ophcrack*
