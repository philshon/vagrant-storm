sudo apt-get update
sudo apt-get install -y unzip
sudo apt-get install -y curl
tar -xvzf /vagrant/storm-0.9.0.1.tar.gz -C /opt/


## Install Oracle Java 7 via PPA (http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html)
sudo apt-get install python-software-properties -y
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
## necessary to automatically accept the Oracle license
sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install oracle-java7-installer -y
# Set oracle Java 7 as the default
sudo apt-get install oracle-java7-set-default -y

## add configurations to the storm.yaml 
sudo cat >> /opt/storm-0.9.0.1/conf/storm.yaml <<EOL
storm.zookeeper.servers:
    - "192.168.99.2"

nimbus.host: "192.168.99.3"

## Use Netty as the transport mechanism
storm.messaging.transport: "backtype.storm.messaging.netty.Context"
storm.messaging.netty.server_worker_threads: 1
storm.messaging.netty.client_worker_threads: 1
storm.messaging.netty.buffer_size: 5242880
storm.messaging.netty.max_retries: 100
storm.messaging.netty.max_wait_ms: 1000
storm.messaging.netty.min_wait_ms: 100

supervisor.slots.ports:
    - 6700
    - 6701
EOL

nohup sudo /opt/storm-0.9.0.1/bin/storm supervisor &
nohup sudo /opt/storm-0.9.0.1/bin/storm logviewer &