#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

echo "Installing dependencies..."
yum install -y wget curl net-tools

echo "Adding MongoDB YUM repository..."
cat > /etc/yum.repos.d/mongodb-org-5.0.repo <<EOF
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-5.0.asc
EOF

echo "Installing MongoDB packages..."
yum install -y mongodb-org

if [ $? -ne 0 ]; then
  echo "MongoDB installation failed."
  exit 1
fi

echo "Configuring MongoDB instances..."

# directories
mkdir -p /var/lib/mongo{1,2,3} /var/log/mongodb
chown -R mongod:mongod /var/lib/mongo{1,2,3} /var/log/mongodb

# Configuration filess
cat > /etc/mongod1.conf <<EOF
# Primary node configuration
storage:
  dbPath: /var/lib/mongo1
  journal:
    enabled: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
systemLog:
  destination: file
  path: /var/log/mongodb/mongod1.log
net:
  port: 27017
  bindIp: 0.0.0.0
replication:
  replSetName: "rs0"
security:
  javascriptEnabled: false
EOF

cat > /etc/mongod2.conf <<EOF
# Secondary node configuration
storage:
  dbPath: /var/lib/mongo2
  journal:
    enabled: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
systemLog:
  destination: file
  path: /var/log/mongodb/mongod2.log
net:
  port: 27018
  bindIp: 0.0.0.0
replication:
  replSetName: "rs0"
security:
  javascriptEnabled: false
EOF

cat > /etc/mongod3.conf <<EOF
# Arbiter configuration
storage:
  dbPath: /var/lib/mongo3
  journal:
    enabled: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
systemLog:
  destination: file
  path: /var/log/mongodb/mongod3.log
net:
  port: 27019
  bindIp: 0.0.0.0
replication:
  replSetName: "rs0"
security:
  javascriptEnabled: false
EOF

echo "Starting MongoDB instances"
mongod --config /etc/mongod1.conf --fork
mongod --config /etc/mongod2.conf --fork
mongod --config /etc/mongod3.conf --fork

sleep 10

echo "Initiating the MongoDB replica set"

mongosh --port 27017 <<EOF
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "localhost:27017" },
    { _id: 1, host: "localhost:27018" },
    { _id: 2, host: "localhost:27019", arbiterOnly: true }
  ]
})
EOF

if [ $? -ne 0 ]; then
  echo "Replica set initiation failed."
  exit 1
fi

echo "Replica set initiated successfully."

echo "Checking replica set status"
mongosh --port 27017 --eval 'rs.status()'
echo "Done"

