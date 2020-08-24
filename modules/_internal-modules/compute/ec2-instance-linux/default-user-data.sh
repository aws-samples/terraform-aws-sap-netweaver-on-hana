#/bin/bash
### Install AWS CLI
echo "Starting user data..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

### Install Systems Manager Agent
DISTRO=`hostnamectl | grep "Operating system"`
case $DISTRO in
  *"SUSE"*)
    mkdir /tmp/ssm
    cd /tmp/ssm
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo rpm --install amazon-ssm-agent.rpm
    ;;
  *"Red Hat"*)
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    ;;
esac

sudo systemctl status amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent


### Install CloudWatch Agent


