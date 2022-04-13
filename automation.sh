#!/bin/bash
s3bucket="upgrad-vivek/logs"
name="vivek"

  sudo apt install apache2 -y
        echo "apache2 is installed"


sudo systemctl unmask apache2

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
        echo "Apache2 is already running"
else
                sudo service apache2 start
        echo "apache2 is now started"



fi

if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
        echo "Apache2 is already enabled"
else
                sudo systemctl enable apache2
        echo "Apache2 is now enabled"
fi

timestp=$(date '+%d%m%Y-%H%M%S')


cd /var/log/apache2/
tar -cvf /tmp/${name}-httpd-logs-${timestp}.tar *.log

sudo apt-get install awscli -y

aws s3 \
cp /tmp/${name}-httpd-logs-${timestp}.tar \
s3://${s3bucket}/${name}-httpd-logs-${timestp}.tar