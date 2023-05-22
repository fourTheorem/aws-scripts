#!/bin/bash
set -euo pipefail

## go to tmp directory
cd /tmp

## Ensure AWS CLI v2 is installed
sudo yum -y remove aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm awscliv2.zip
export PATH=~/.local/bin:$PATH

# Install newer version of AWS SAM CLI
wget -q https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install --update
rm -rf ./sam-installation/
rm ./aws-sam-cli-linux-x86_64.zip


## Resize disk
cd /home/ec2-user/environment/aws-scripts
chmod +x resize.sh
./resize.sh 20

## Install python 3.10
# Update sudo config to enable sudo check in homebrew
# https://github.com/Homebrew/install/issues/369
# https://askubuntu.com/questions/1195249/sudo-validate-sudo-v-asks-for-password-even-with-nopasswd/1211226
cd /home/ec2-user/environment/
echo "Defaults verifypw = any" | sudo tee /etc/sudoers.d/100-linuxbrew-install

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure Homebrew as per instructions printed from install
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/ec2-user/.bash_profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install our dependencies (slow on a t2.micro)
brew install python@3.10 jq awscli aws-sam-cli 

# Force python 3.10 to top of PATH
echo 'PATH=/home/linuxbrew/.linuxbrew/opt/python@3.10/libexec/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile

# Install poetry
curl -sSL https://install.python-poetry.org | python3.10 -

## Install additional dependencies
sudo yum install -y jq
