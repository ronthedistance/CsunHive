#!/bin/bash

echo "Are you sure you want to delete user: $1"
read input
if [[ $input == "yes" ]];
	then
    	userdel $1
else
	echo "Goodbye."
fi
