#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
EC2AZ=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone`
sudo echo '<h1><center>Hello World!</h1></center><p><center><h2>This instance is located in Availability Zone: AZID </h2></center>' > /var/www/html/index.txt
sudo sed "s/AZID/$EC2AZ/" /var/www/html/index.txt > /var/www/html/index.html
