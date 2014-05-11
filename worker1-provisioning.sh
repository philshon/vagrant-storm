sudo apt-get update
sudo apt-get install -y unzip curl openjdk-7-jdk
tar -xvzf /vagrant/storm-0.9.0.1.tar.gz -C /opt/

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
