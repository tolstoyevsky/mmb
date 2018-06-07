CORES_NUMBER="$(grep -c ^processor /proc/cpuinfo)"

NODE_VERSION=8.11.2

NVM_VERSION=0.33.11

if [ -f "${CHROOT_DIR}/etc/alpine-release" ]; then
    # Install dependencies for building the latest Node.js LTS.
    chroot_exec \
        apk --update add \
            curl \
            gcc \
            gnupg \
            g++ \
            linux-headers \
            make \
            python

    chroot_exec curl -LO "https://github.com/nodejs/node/archive/v${NODE_VERSION}.tar.gz"

    chroot_exec tar xzvf "v${NODE_VERSION}.tar.gz"

    chroot_exec sh -c "cd node-${NODE_VERSION} && ./configure --prefix=/usr && make -j${CORES_NUMBER} && make install"

    # Cleanup

    chroot_exec \
        apk del \
            curl \
            gcc \
            gnupg \
            g++ \
            linux-headers \
            make \
            python

    # Cleanup had an impact on libstdc++ because it had been installed as a
    # dependency for g++. Fixing it.
    chroot_exec \
        apk add libstdc++

    rm -r "${CHROOT_DIR}/node-${NODE_VERSION}"

    rm    "${CHROOT_DIR}/v${NODE_VERSION}.tar.gz"

    rm -f "${CHROOT_DIR}"/var/cache/apk/*
else
    info "doing nothing."
fi
