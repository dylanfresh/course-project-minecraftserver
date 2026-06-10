# Welcome! Here we will setup a minecraft server on AWS services.
This tutorial is written for Unix based systems, if you are on Windows we recommend using a VM.

## Step 1: Download the zip file from the repo.
Firstly, download the files from this repo to get started.

## Step 2: Install all required packages.
Install the following:
- AWS CLI v2
- Terraform
- Ansible

### Step 2.1: Install Terraform
Download the Terraform package using your systems respective package manager.
MacOS: `brew tap hashicorp/tap` then `brew install hashicorp/tap/terraform`
Linux: `sudo apt-get install -y terraform`

## Step 3: Configure your AWS credentials.
Use `aws configure` and set your region to us-east-1 and output as json.

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

## Step 4: Generate SSH Key
Use the following to generate a key pair to use with Terraform, allowing it to setup the AWS resources and utilize Ansible later on.
`ssh-keygen -t ed25519 -f ~/.ssh/minecraft_key`

## Step 5: Run the deploy.sh file to get your server going!
Firstly, run `chmod +x deploy.sh` in the file location to setup the deploy script. Use `./deploy.sh ` to get the server running. Once this script is complete you can test connection on your minecraft client, or test using `nmap -sV -Pn -p 25565 <PUBLIC_IP>`. (The script will also print an nmap command you can use to test.)

