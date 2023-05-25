#!/bin/bash
set -euo pipefail


cat << EOF > /tmp/boostrap-ec2-user.sh
#!/bin/bash
set -euo pipefail

# Update sudo config to enable sudo check in homebrew
# https://github.com/Homebrew/install/issues/369
# https://askubuntu.com/questions/1195249/sudo-validate-sudo-v-asks-for-password-even-with-nopasswd/1211226
echo "Defaults verifypw = any" | sudo tee /etc/sudoers.d/100-linuxbrew-install

# Install homebrew
/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure Homebrew as per instructions printed from install
(echo; echo 'eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/ec2-user/.bash_profile
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install our dependencies (slow on a t2.micro)
brew install python@3.10 jq awscli aws-sam-cli

# Force python 3.10 to top of PATH
echo 'PATH=/home/linuxbrew/.linuxbrew/opt/python@3.10/libexec/bin:\$PATH' >> ~/.bash_profile
export PATH=/home/linuxbrew/.linuxbrew/opt/python@3.10/libexec/bin:\$PATH

# Install poetry
curl -sSL https://install.python-poetry.org | python3.10 -
EOF

chmod 755 /tmp/boostrap-ec2-user.sh

sudo su -l ec2-user /tmp/boostrap-ec2-user.sh
