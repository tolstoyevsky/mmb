DEBOOTSTRAP_VER="1.0.91"
DEBOOTSTRAP_EXEC="env DEBOOTSTRAP_DIR=`pwd`/debootstrap ./debootstrap/debootstrap"

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
    >&2 echo "${text_in_red_color}Fatal${reset}: ${*}"
}

# Prints the specified message with the level info.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
info() {
    >&2 echo "${text_in_yellow_color}Info${reset}: ${*}"
}

# Prints the specified message with the level success.
# Globals:
#     None
# Arguments:
#     Message
# Returns:
#     None
success() {
    >&2 echo "${text_in_green_color}Success${reset}: ${*}"
}

# Checks if all required dependencies are installed on the system.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
check_dependencies() {
    if [ -z `which docker` ]; then
        fatal "Docker is not installed." \
              "Run apt-get install docker.io on Debian/Ubuntu to fix it."
        exit 1
    fi

    if [ -z `which git` ]; then
        fatal "git is not installed." \
              "Run apt-get install git on Debian/Ubuntu to fix it."
        exit 1
    fi

    if [ -z `which wget` ]; then
        fatal "wget is not installed." \
              "Run apt-get install wget on Debian/Ubuntu to fix it."
        exit 1
    fi

    if [ -z `which xz` ]; then
        fatal "xz is not installed." \
              "Run apt-get install xz-utils on Debian/Ubuntu to fix it."
        exit 1
    fi
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

# Get qemu-user-static 2.8 from the Debian archive.
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
get_qemu_arm_static() {
    wget http://ftp.debian.org/debian/dists/stretch/main/binary-amd64/Packages.xz

    xz -d Packages.xz

    package=`grep "Filename: pool/main/q/qemu/qemu-user-static" Packages | awk '{print $2}'`

    wget http://ftp.debian.org/debian/${package}

    ar x `basename ${package}`

    tar xJvf data.tar.xz

    cp usr/bin/qemu-arm-static .
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
    git -C debootstrap checkout ${DEBOOTSTRAP_VER}

    # After cloning the debootstrap git repo the program is a fully
    # functional, but does not have a correct version number. However, the
    # version can be found in the source package changelog.
    ver=`sed 's/.*(\(.*\)).*/\1/; q' debootstrap/debian/changelog`
}

# Parses command line options.
# Globals:
#     FLAVOUR
#     TAG_NAME
# Arguments:
#     Command line as an array
# Returns:
#     None
parse_options() {
    while true; do
        case "$1" in
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
