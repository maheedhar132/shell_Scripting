echo "Installing kubectl from the official binary........."
echo ".........."
echo "Downloading the binary....."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo "Validate the Binary........."
echo "Download the checksum file....."
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "Validate the binary against the checksum file.."
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
echo "Install the kubectl binary........."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "Check the kubectl version"
kubectl version --client


#Installing AWS-cli
echo "Download awscli.zip........"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
echo "Unzip the binary..."
unzip awscliv2.zip
echo "Install the binary...."
sudo ./aws/install
echo "Version check...."
aws --version


#Install eks-ctl
echo "Installing eks-ctl...."
echo "Downloading the binary........."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
echo "Move the binary to /usr/local/bin..........."
sudo mv /tmp/eksctl /usr/local/bin



#Check all the installations

echo "Checking all the installations......."
echo "Kubectl version: "
kubectl version --client
echo "awscli version: "
aws --version
echo "eksctl version: "
eksctl version
