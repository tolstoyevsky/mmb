CORES_NUMBER="$(grep -c ^processor /proc/cpuinfo)"

NODE_VERSION=8.11.2

# Install dependencies for building the latest Node.js LTS.

if is_alpine; then
    chroot_exec \
        apk --update add \
            curl \
            gcc \
            gnupg \
            g++ \
            linux-headers \
            make \
            python
elif is_debian; then
    chroot_exec apt-get update

    chroot_exec \
        apt-get install -y \
            curl \
            build-essential \
            python
else
    fatal "unknown distro."
fi

# Download the latest Node.js LTS and build it.

chroot_exec curl -LO "https://github.com/nodejs/node/archive/v${NODE_VERSION}.tar.gz"

chroot_exec tar xzvf "v${NODE_VERSION}.tar.gz"

chroot_exec sh -c "cd node-${NODE_VERSION} && ./configure --prefix=/usr && make -j${CORES_NUMBER} && make install"

# Cleanup

if is_alpine; then
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

    rm -f "${CHROOT_DIR}"/var/cache/apk/*
elif is_debian; then
    chroot_exec \
        apt-get purge -y \
            curl \
            build-essential \
            python

    chroot_exec apt-get autoremove -y

    chroot_exec apt-get clean

    rm -rf "${CHROOT_DIR}"/var/lib/apt/lists/*
else
    fatal "unknown distro."
fi

rm -r "${CHROOT_DIR}/node-${NODE_VERSION}"

rm    "${CHROOT_DIR}/v${NODE_VERSION}.tar.gz"
