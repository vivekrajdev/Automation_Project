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

if [ -e /var/www/html/inventory.html ]
then
        echo "Inventory exists"
else
        touch /var/www/html/inventory.html
        echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> /var/www/html/inventory.html
fi

echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp; `du -h /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $1}'`" >> /var/www/html/inventory.html

if [ -e /etc/cron.d/automation ]
then
        echo "Cron job exists"
else
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "Cron job added"
fi
