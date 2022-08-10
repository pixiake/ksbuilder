#!/bin/sh

echo "************************************"
echo     1. Loading KubeSphere images
echo "************************************"

for image in $(ls /kubesphere/images/*.tar); do ctr i import ${image}; done

echo "************************************"
echo     2. Launching KubeSphere
echo "************************************"

kubectl create ns kubesphere-controls-system

helm upgrade --install ks-core ./ks-core/ --namespace kubesphere-system --create-namespace \
--kubeconfig /etc/rancher/k3s/k3s.yaml \
--set image.ks_apiserver_repo=kubespheredev/ks-apiserver \
--set image.ks_apiserver_tag=feature-pluggable \
--set image.ks_controller_manager_repo=kubespheredev/ks-controller-manager \
--set image.ks_controller_manager_tag=feature-pluggable \
--set image.ks_console_repo=kubespheredev/ks-console \
--set image.ks_console_tag=feature-pluggable


