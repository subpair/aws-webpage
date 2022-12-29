#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
EC2AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
sudo echo '<h1><center>Hello World!</h1></center><p><center><h2>This instance is located in Availability Zone: AZID </h2></center>' > /var/www/html/index.txt
sudo sed "s/AZID/$EC2AZ/" /var/www/html/index.txt > /var/www/html/index.html
