sudo yum update -y
echo "Installing wget"
sudo yum install wget -y
echo "Installing Java"
sudo yum install java-1.8.0-openjdk.x86_64 -y

sudo mkdir /app && cd /app
echo "Download latest version of Nexus"
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
echo "Setting up Nexus"
sudo tar -xvf nexus.tar.gz
sudo mv nexus-3* nexus

sudo sed -i 's/run_as_user/run_as_user="nexus"/g' /app/nexus/bin/nexus.rc
sudo printf "-Xms2703m
-Xmx2703m
-XX:MaxDirectMemorySize=2703m
-XX:+UnlockDiagnosticVMOptions
-XX:+UnsyncloadClass
-XX:+LogVMOutput
-XX:LogFile=../sonatype-work/nexus3/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=etc/karaf/java.util.logging.properties
-Dkaraf.data=/nexus/nexus-data
-Djava.io.tmpdir=../sonatype-work/nexus3/tmp
-Dkaraf.startLocalConsole=false
-Dkaraf.data=/app/sonatye" > nexus.vmoptions

sudo printf "[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target" > nexus.service

sudo mv nexus.service /etc/systemd/system
sudo mv nexus.vmoptions /app/nexus/bin/nexus.vmoptions


sudo adduser nexus
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

sudo chkconfig nexus on

sudo systemctl start nexus
