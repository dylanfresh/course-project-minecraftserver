# Welcome! Here we will setup a minecraft server on AWS services.
This tutorial is written for Unix based systems, if you are on Windows we recommend using a VM.

## Step 1: Download the zip file from the repo.
Firstly, download the files from this repo to get started.

## Step 2: Configure your AWS CLI.
Ensure you have AWS CLI installed on your machine, and use `aws configure` to setup with your credentials.

# Infrastructure
The project will use Terraform to automatically setup all required AWS infrastructure.
This will give us the following setup:
- VPC: `10.0.0.0/16`
- Public Subnet: `10.0.1.0/24`
- Internet Gateway
- Route Table and Association
- Security Group Rules:
1. TCP 22 (SSH)
2. TCP 25565 (Minecraft Server)
- EC2 Instance (t3.small)
- AWS Key Pair

## Step 3: Generate SSH Key
Use the following to generate a key pair to use with Terraform, allowing it to setup the AWS resources and utilize Ansible later on.
`ssh-keygen -t ed25519 -f ~/.ssh/minecraft_key`

## Step 4: Install and Initialize Terraform
After downloading Terraform from the CLI, use `terraform init` to initiate the service. Validate using `terraform validate` and then execute the Terraform script to setup infrastructure by doing `terraform apply \ -var="public_key_path=$HOME/.ssh/minecraft_key.pub"`
IN CASE OF ERRORS: To remove all resources: `terraform destroy \ -var="public_key_path=$HOME/.ssh/minecraft_key.pub"`
