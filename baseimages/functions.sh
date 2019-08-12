# Copyright 2018 Evgeny Golyshev. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEBOOTSTRAP_VER="1.0.91"
DEBOOTSTRAP_EXEC="env DEBOOTSTRAP_DIR=$(pwd)/debootstrap ./debootstrap/debootstrap"

text_in_red_color=$(tput setaf 1)

text_in_green_color=$(tput setaf 2)

text_in_yellow_color=$(tput setaf 3)

reset=$(tput sgr0)

# Prints the specified message with the level fatal.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
fatal() {
    >&2 echo "${text_in_red_color}Fatal${reset}: $*"
}

# Prints the specified message with the level info.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
info() {
    >&2 echo "${text_in_yellow_color}Info${reset}: $*"
}

# Prints the specified message with the level success.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
success() {
    >&2 echo "${text_in_green_color}Success${reset}: $*"
}

# Check if the specified architecture is valid.
# Globals:
#     ARCH
# Arguments:
#     None
# Returns:
#     Boolean
is_architecture_valid() {
    case "${ARCH}" in
    armhf|amd64)
        true
        ;;
    *)
        false
        ;;
    esac
}

# Checks if the target distribution is Alpine.
# Globals:
#     CHROOT_DIR
# Arguments:
#     None
# Returns:
#     Boolean
is_alpine() {
    if [ -f "${CHROOT_DIR}/etc/alpine-release" ]; then
        true
    else
        false
    fi
}

# Checks if the target distribution is Debian.
# Globals:
#     CHROOT_DIR
# Arguments:
#     None
# Returns:
#     Boolean
is_debian() {
    if [ -f "${CHROOT_DIR}/etc/debian_version" ]; then
        true
    else
        false
    fi
}

# Checks if all required dependencies are installed on the system.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
check_dependencies() {
    if [ -z "$(command -v docker)" ]; then
        fatal "Docker is not installed." \
              "Run apt-get install docker.io on Debian/Ubuntu to fix it."
        exit 1
    fi

    if [ -z "$(command -v git)" ]; then
        fatal "git is not installed." \
              "Run apt-get install git on Debian/Ubuntu to fix it."
        exit 1
    fi

    if [ -z "$(command -v wget)" ]; then
        fatal "wget is not installed." \
              "Run apt-get install wget on Debian/Ubuntu to fix it."
        exit 1
    fi

    if [ -z "$(command -v xz)" ]; then
        fatal "xz is not installed." \
              "Run apt-get install xz-utils on Debian/Ubuntu to fix it."
        exit 1
    fi
}

# Choose the suitable user mode emulation binary depending on the ARCH value.
# Globals:
#     ARCH
#     EMULATION_BINARY
# Arguments:
#     None
# Returns:
#     None
choose_emulator() {
    case "${ARCH}" in
    amd64|x86_64)
        EMULATION_BINARY="qemu-x86_64-static"
        ;;
    armhf)
        EMULATION_BINARY="qemu-arm-static"
        ;;
    *)
        EMULATION_BINARY=""
        ;;
    esac
}

# Executes the specified command in the chroot environment.
# Globals:
#     CHROOT_DIR
# Arguments:
#     None
# Returns:
#     None
chroot_exec() {
    chroot "${CHROOT_DIR}" "$@" 1>&2
}

# Get qemu-user-static 2.11 from Ubuntu Bionic (LTS).
# Globals:
#     EMULATION_BINARY
# Arguments:
#     None
# Returns:
#     None
get_qemu_emulation_binary() {
    wget http://mirrors.kernel.org/ubuntu/dists/bionic/universe/binary-amd64/Packages.xz

    xz -d Packages.xz

    package="$(grep "Filename: pool/universe/q/qemu/qemu-user-static" Packages | awk '{print $2}')"

    wget http://security.ubuntu.com/ubuntu/"${package}"

    ar x "$(basename "${package}")"

    tar xJvf data.tar.xz

    cp usr/bin/"${EMULATION_BINARY}" .
}

# Get the latest version of debootstrap.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
get_debootstrap() {
    git clone https://anonscm.debian.org/git/d-i/debootstrap.git
    git -C debootstrap checkout "${DEBOOTSTRAP_VER}"
}

# Parses command line options.
# Globals:
#     ARCH
#     FLAVOUR
#     TAG_NAME
#     USE_EMULATION
# Arguments:
#     Command line as an array
# Returns:
#     None
parse_options() {
    while true; do
        case "$1" in
        -a|--arch)
            ARCH="$2"
            shift 2
            ;;
        -f|--flavour)
            FLAVOUR="$2"
            shift 2
            ;;
        -t|--tag-name)
            TAG_NAME="$2"
            shift 2
            ;;
        *)
            break
            ;;
        esac
    done
}

# Calls the cleanup function on the following signals: EXIT, SIGHUP, SIGINT,
# SIGQUIT and SIGABRT.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
set_traps() {
    trap cleanup 0 1 2 3 6
}

# Cleans up the build environment.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
cleanup() {
    set -x

    # Alpine
    rm  -f .PKGINFO
    rm  -f .SIGN.RSA*
    rm -rf sbin

    # qemu-arm-static
    rm  -f qemu-user-static_*.deb
    rm  -f control.tar.*
    rm  -f data.tar.*
    rm  -f debian-binary
    rm  -f Packages
    rm  -f Packages.gz
    rm -rf usr

    set +x
}

# Transforms user the defined arch into the target arch.
# Globals:
#     TARGET_ARCH
# Arguments:
#     User defined arch
# Returns:
#     None
user_defined_arch_to_target_arch() {
    case "${ARCH}" in
    amd64|x86_64)
        TARGET_ARCH="x86_64"
        ;;
    armhf)
        TARGET_ARCH="armv7l"
        ;;
    *)
        fatal "the specified architecture '${ARCH}' is not supported."
        exit 1
        ;;
    esac
}
