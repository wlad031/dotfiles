FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TEA_VERSION=0.14.0

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ansible \
      ca-certificates \
      curl \
      gnupg \
      python3-yaml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN arch="$(dpkg --print-architecture)" \
    && case "${arch}" in \
      amd64) tea_arch="amd64" ;; \
      arm64) tea_arch="arm64" ;; \
      *) echo "Unsupported architecture: ${arch}" && exit 1 ;; \
    esac \
    && curl -fsSL "https://dl.gitea.com/tea/${TEA_VERSION}/tea-${TEA_VERSION}-linux-${tea_arch}" -o /usr/local/bin/tea \
    && chmod +x /usr/local/bin/tea \
    && tea --version
