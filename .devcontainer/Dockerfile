FROM alpine:latest

RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    aws-cli

RUN curl -fsSL https://releases.hashicorp.com/terraform/1.12.1/terraform_1.12.1_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

RUN mkdir -p /.vscode-server/bin && \
    chmod -R 777 /.vscode-server

ENV PATH="/root/.local/bin:$PATH"