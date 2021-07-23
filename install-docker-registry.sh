#!/bin/sh

echo Installing, enabling and podman and starting docker service.
sudo dnf install -y docker
echo Pull registry and start registry container
sudo docker pull registry
sudo docker run -dit -p 5000:5000 --name registry registry
echo Show docker processes
sudo docker ps
echo Install Kubectl cli
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo Done!
