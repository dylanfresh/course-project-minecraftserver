#!/bin/bash

set -e

echo "Starting Minecraft infrastructure deployment..."

echo "Running Terraform..."

cd terraform

terraform init
terraform apply -auto-approve \
  -var="public_key_path=$HOME/.ssh/minecraft_key.pub"

echo "Getting public IP..."

PUBLIC_IP=$(terraform output -raw public_ip)

echo "Public IP: $PUBLIC_IP"

until nc -z $PUBLIC_IP 22; do
  echo "SSH not ready yet... retrying in 5 seconds"
  sleep 5
done

cd ..

echo "Creating Ansible inventory..."

cat > ansible/inventory.ini <<EOF
[minecraft]
$PUBLIC_IP ansible_user=ubuntu
EOF

echo "Running Ansible playbook..."

export ANSIBLE_HOST_KEY_CHECKING=False

cd ansible

ansible-playbook \
  -i inventory.ini \
  -u ubuntu \
  --private-key ~/.ssh/minecraft_key \
  playbook.yml

cd ..

echo "Deployment complete."
echo "Minecraft server is running at: $PUBLIC_IP"
echo "Test with: nmap -sV -Pn -p 25565 $PUBLIC_IP"
