#!/bin/bash

sudo apt-get autoremove -y;

sudo apt-get autoclean -y;

sudo updatedb;

sudo apt-get update -y;

sudo apt-get upgrade -y;
