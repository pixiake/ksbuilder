# Build the manager binary
FROM golang:1.17 as builder

ENV ARCH=amd64

WORKDIR /workspace

RUN if [[ $(arch) == aarch64* ]]; then ARCH=arm64; fi && \
    wget https://get.helm.sh/helm-v3.9.0-linux-${ARCH}.tar.gz && \
    tar -zxf helm-v3.9.0-linux-${ARCH}.tar.gz && \
    mv linux-${ARCH}/helm . && \
    rm -rf *linux-${ARCH}* && \
    chmod +x ./helm && \
    wget https://github.com/kubesphere/ksbuilder/releases/download/v0.0.1-alpha2/ksbuilder_0.0.1-alpha2_linux_${ARCH}.tar.gz && \
    tar -zxf ksbuilder_0.0.1-alpha2_linux_${ARCH}.tar.gz && \
    chmod +x ./ksbuilder


FROM rancher/k3s:v1.23.9-k3s1

WORKDIR /kubesphere

COPY --from=builder /workspace/helm /bin/helm
COPY --from=builder /workspace/ksbuilder /bin/ksbuilder

ADD images ./images
ADD bootstrap.sh ./bootstrap.sh
ADD ks-core ./ks-core


