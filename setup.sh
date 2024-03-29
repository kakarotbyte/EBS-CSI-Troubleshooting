#! /bin/bash

echo "Installing terraform"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

echo "Installing helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

echo "Installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "alias k=kubectl" >> /home/ec2-user/.bashrc

echo "Installing kubectx"
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kctx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kns
sudo ln -s /usr/bin/terraform /usr/local/bin/t
sudo ln -s /usr/bin/kubectl /usr/local/bin/k


terraform init
terraform apply -auto-approve

echo "wait for cluster 1"
aws eks wait cluster-active --name ebs-demo-1

echo "adding kubeconfig"
aws eks update-kubeconfig --name ebs-demo-1

sleep 2

echo "wait for cluster 1"
aws eks wait cluster-active --name ebs-demo-2

aws eks update-kubeconfig --name ebs-demo-2

kubectl apply -f default-pod.yaml
sleep 2
aws eks wait cluster-active --name ebs-demo-3
aws eks update-kubeconfig --name ebs-demo-3
sleep 2
kubectl apply -f resizer-sc.yaml
sleep 30
kubectl patch pvc ebs-claim-resizer -p '{"spec":{"resources":{"requests":{"storage":"600Gi"}}}}'
sleep 2
kubectl patch pvc ebs-claim-resizer -p '{"spec":{"resources":{"requests":{"storage":"700Gi"}}}}'


source /home/ec2-user/.bashrc
