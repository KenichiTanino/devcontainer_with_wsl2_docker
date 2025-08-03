FROM rockylinux:9

# Docker build-arg for the target architecture
ARG TARGETARCH

# 1. Update and install basic dependencies
RUN dnf update -y && \
    dnf install -y --allowerasing python3.12 python3.12-pip gcc && dnf clean all

# 2. Install Node.js
RUN curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - && \
    dnf install -y nodejs && \
    dnf clean all

# 3. Install nfpm for the correct architecture
RUN ARCH=${TARGETARCH:-amd64} && \
    if [ "$ARCH" = "amd64" ]; then ARCH_SUFFIX="x86_64"; else ARCH_SUFFIX=$ARCH; fi && \
    curl -L "https://github.com/goreleaser/nfpm/releases/download/v2.38.0/nfpm_2.38.0_Linux_${ARCH_SUFFIX}.tar.gz" | tar -xz -C /usr/local/bin nfpm && \
    chmod +x /usr/local/bin/nfpm

# 4. Install Task
RUN curl -sL https://taskfile.dev/install.sh | sh -s -- -d -b /usr/local/bin
