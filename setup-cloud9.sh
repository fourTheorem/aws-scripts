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

## Install additional dependencies
sudo yum install -y jq

## Resize disk
/home/ec2-user/environment/aws-scripts/resize.sh 20

