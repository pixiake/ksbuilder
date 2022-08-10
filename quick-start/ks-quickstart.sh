#!/bin/bash

which docker > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo ""
  echo -e "\033[1;36mPlease install 'docker' first.\033[0m"
  echo ""
  echo "The following method can be used to quickly install docker:"
  echo ""
  echo "    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun"
  echo ""
  exit 1
fi

sudo docker ps -a --filter "name=ks-quickstart" >/dev/null
if [ $? -ne 0 ]; then
  exit 1
fi

echo "************************************"
echo     0. Starting quickstart cluster
echo "************************************"

if [ $(sudo docker ps -a --filter "name=ks-quickstart" | wc -l) -eq 2 ]; then
  sudo docker rm ks-quickstart -f
fi

sudo docker run -d --name ks-quickstart \
     -v /etc/rancher:/etc/rancher \
     --network=host --privileged=true --restart=always \
     kubespheredev/ks-quickstart:v0.0.1 \
     server --cluster-init --disable-cloud-controller --disable=servicelb,traefik,metrics-server --write-kubeconfig-mode=644

sleep 3

if [ "x$(uname)" != "xLinux" ]; then
  echo ""
  echo -e "\033[1;36mWarning: Automatic installation of helm, kubectl and ksbuilder is not supported on Non-Linux operating systems.\033[0m"
else
  which helm > /dev/null 2>&1
    if [ $? -ne 0 ]; then
       sudo docker cp  ks-quickstart:/bin/helm /usr/local/bin/
    fi
  which kubectl > /dev/null 2>&1
    if [ $? -ne 0 ]; then
       sudo sudo docker cp  ks-quickstart:/bin/k3s /usr/local/bin/kubectl
    fi
  which ksbuilder > /dev/null 2>&1
    if [ $? -ne 0 ]; then
       sudo sudo docker cp  ks-quickstart:/bin/ksbuilder /usr/local/bin/ksbuilder
    fi
fi

sudo docker exec ks-quickstart  /bin/sh /kubesphere/bootstrap.sh
