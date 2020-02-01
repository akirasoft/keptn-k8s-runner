FROM alpine:3.9

# Install tools:
RUN apk add --update --no-cache \
    bash \
    bc \
    ca-certificates \
    core-utils \
    curl \
    git \
    gnupg \
    jq \
    wget \
    vim \
    && rm -rf /var/cache/apk/*

ARG YQ_VERSION=2.3.0
RUN wget -q https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 -O /bin/yq && \
  chmod +x /bin/yq
RUN yq --version

ARG HELM_VERSION=2.12.3
RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  tar -zxvf helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  mv linux-amd64/helm /bin/helm && \
  rm -f helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  rm -rf linux-amd64

ARG KUBE_VERSION=1.14.1
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl -O /bin/kubectl && \
  chmod +x /bin/kubectl

######################################################################
# Keptn CLI
######################################################################
ARG CLI_VERSION=0.6.0
ARG CLI_DISTRO=linux
RUN curl -sL https://github.com/keptn/keptn/releases/download/${CLI_VERSION}/${CLI_VERSION}_keptn-${CLI_DISTRO}.tar --output ${CLI_VERSION}_keptn.tar
RUN tar -C /tmp -xf ${CLI_VERSION}_keptn.tar
RUN chmod +x /tmp/keptn
RUN mv /tmp/keptn /usr/local/bin/keptn
RUN rm -rf ${CLI_VERSION}_keptn.tar
RUN keptn version

# Start the app
CMD ["/bin/bash"]
