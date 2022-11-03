#!/bin/bash

#Setup PostgreSQL 10 Database For SonarQube

#Prep the Server With the Required Software
while getopts ":lu" option;
do
 case $option in 
 l) echo "Linux OS selected"
    sudo yum update -y
	
    echo "Installing wget and unzip"
    sudo yum install wget unzip -y
	
    echo "Installing Java11"
    sudo yum install java-11-openjdk-devel -y
	
	echo "Login as root and execute the following commands"
	sudo sysctl vm.max_map_count && sudo sysctl fs.file-max && sudo ulimit -n && sudo ulimit -u
    cd /opt
	
    echo "Download latest version of Sonarqube"
    sudo wget -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.7.1.62043.zip
	
    echo "Setting up Sonarqube"
    sudo tar -xvf nexus.tar.gz
	sudo unzip sonarqube-9.7.1.62043.zip
	sudo mv sonarqube-9.7.1.62043 sonarqube

    sudo chown -R nexus:nexus /app/nexus
    sudo chown -R nexus:nexus /app/sonatype-work
    sudo chkconfig nexus on
    ;;
 u) echo "Ubuntu OS selected"
    sudo apt update -y
    echo "Installing Wget"
    sudo apt install wget unzip -y
    echo "Installing Java"
    sudo apt-get install openjdk-8-jdk -y
    sudo useradd nexus
    sudo mkdir /app && cd /app
    echo "Download latest version of Nexus"
    sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
    echo "Setting up Nexus"
    sudo tar -xvf nexus.tar.gz
    

    sudo mv nexus-3* nexus

    sudo sed -i 's/run_as_user/run_as_user="nexus"/g' /app/nexus/bin/nexus.rc 

    sudo mv $dir/nexus.service /etc/systemd/system
    sudo mv $dir/nexus.vmoptions /app/nexus/bin/nexus.vmoptions
#Setup Sonar User and Database

#Setup Sonarqube Web Server

sudo printf "sonar.jdbc.username=sonar                                                                                                                 
sonar.jdbc.password=sonar-db-password
sonar.jdbc.url=jdbc:postgresql://localhost/onarqubedb
#Setting up Sonarqube as a service

sudo printf "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=sonarqube
Group=sonarqube
PermissionsStartOnly=true
ExecStart=/bin/nohup java -Xms32m -Xmx32m -Djava.net.preferIPv4Stack=true -jar /opt/sonarqube/lib/sonar-application-9.7.1.62043.jar
StandardOutput=syslog
LimitNOFILE=65536
LimitNPROC=8192
TimeoutStartSec=5
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/sonarqube.service

sudo systemctl start sonarqube
sudo systemctl enable sonarqube

