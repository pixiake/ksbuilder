#!/bin/bash

images=(kubesphere/kubectl:latest
    kubespheredev/ks-apiserver:feature-pluggable
    kubespheredev/ks-console:feature-pluggable
    kubespheredev/ks-controller-manager:feature-pluggable
    mirrorgooglecontainers/defaultbackend-amd64:1.4
    rancher/mirrored-coredns-coredns:1.9.1
    rancher/local-path-provisioner:v0.0.21
)

for image in "${images[@]}"; do
    docker pull "$image"
    ImageName=${image#*/}
    docker save -o images/${ImageName}.tar $image
done
