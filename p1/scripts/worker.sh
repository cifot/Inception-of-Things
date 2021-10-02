#!/bin/sh

# Deploy keys to allow all nodes to connect each others as root
mv /tmp/id_rsa*  /root/.ssh/

chmod 400 /root/.ssh/id_rsa*
chown root:root  /root/.ssh/id_rsa*

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 400 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

# Add current node in  /etc/hosts
echo "127.0.1.1 $(hostname)" >> /etc/hosts

# Get current IP adress to launch k3S
current_ip=$(hostname -I | awk '{print $2}')

# Add nharraS in  /etc/hosts
echo "192.168.42.110  nharraS" >> /etc/hosts



# Launch k3s as agent
scp -o StrictHostKeyChecking=no root@nharraS:/var/lib/rancher/k3s/server/token /tmp/token
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://nharraS:6443 --token-file /tmp/token --node-ip=${current_ip}" sh -