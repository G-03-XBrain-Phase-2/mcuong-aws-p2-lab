#!/bin/bash
# Log output to /var/log/user-data.log for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "=== 1. Install kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

echo "=== 2. Get Public IP of EC2 via IMDSv2 ==="
IMDS_TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
EC2_PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" http://169.254.169.254/latest/meta-data/public-ip)
echo "Public IP is: $EC2_PUBLIC_IP"

echo "=== 3. Install & Configure K3s ==="
# Create token auth file for admin API access
mkdir -p /etc/rancher/k3s
echo "cdo-03-super-secret-token,admin,admin,\"system:masters\"" > /etc/rancher/k3s/token.csv

# Install K3s with static token and include public IP in TLS certificates
curl -sfL https://get.k3s.io | K3S_TOKEN="cdo-03-super-secret-token" sh -s - --tls-san "$EC2_PUBLIC_IP" --kube-apiserver-arg="token-auth-file=/etc/rancher/k3s/token.csv"

# Wait for K3s to be ready
echo "Waiting for K3s API server to start..."
until k3s kubectl get nodes; do
  sleep 2
done

echo "=== 4. Configure Kubeconfig ==="
# Set up kubeconfig for ec2-user
mkdir -p /home/ec2-user/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
sed -i "s/127.0.0.1/$EC2_PUBLIC_IP/g" /home/ec2-user/.kube/config
chown -R ec2-user:ec2-user /home/ec2-user/.kube
chmod 600 /home/ec2-user/.kube/config

# Set up kubeconfig for root
mkdir -p /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
sed -i "s/127.0.0.1/$EC2_PUBLIC_IP/g" /root/.kube/config
chmod 600 /root/.kube/config

echo "=== Setup Completed successfully ==="
