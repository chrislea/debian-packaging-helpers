#!/bin/bash


#------------------------------------------------------------
#
# GLOBALS
#
#------------------------------------------------------------
no_arm=("wheezy" "precise")
arch_options=("armhf" "i386" "amd64")
dist_options=("wheezy" "jessie" "sid" "precise" "trusty" "xenial" "yakkety")


#------------------------------------------------------------
#
# ex: build_armhf trusty
#
# returns true or false depending on the distro name
#
#------------------------------------------------------------
function build_armhf() {
    local dist=$1

    if [[ " ${no_arm[@]} " =~ " ${dist} " ]]; then
        echo "false"
    else
        echo "true"
    fi
}


#------------------------------------------------------------
#
# ex: possible_arch amd64
#
# returns true or false depending on the supplied
# architecture
#
#------------------------------------------------------------
function possible_arch() {
    local arch=$1

    if [[ " ${arch_options[@]} " =~ " ${arch} " ]]; then
        echo "true"
    else
        echo "false"
    fi
}


#------------------------------------------------------------
#
# ex: possible_dist wily
#
# returns true or false depending on the supplied distro
#
#------------------------------------------------------------
possible_dist() {
    local dist=$1

    if [[ " ${dist_options[@]} " =~ " ${dist} " ]]; then
        echo "true"
    else
        echo "false"
    fi
}


#------------------------------------------------------------
#
# ex: run_build precise armhf
#
# returns true or false to indicate whether we should try
# and build the distro / architecture combo provided
#
#------------------------------------------------------------
function run_build() {
    local dist=$1
    local arch=$2

    if [ "x$(possible_dist $1)" == "xfalse" ]; then
        echo "false"
    elif [ "x$(possible_arch $2)" == "xfalse" ]; then
        echo "false"
    elif [[ "x${arch}" == "xarmhf" && "x$(build_armhf $dist)" == "xfalse" ]]; then
        echo "false"
    else
        echo "true"
    fi
}


#------------------------------------------------------------
#
# ex: compiler_vars trusty
#
# returns a string with environment variables to set the
# compilers to use
#
#------------------------------------------------------------
function compiler_vars() {
    local dist=$1
    local cc="/usr/bin/gcc"
    local cxx="/usr/bin/g++"

    # we use clang on debian wheezy and ubuntu precise
    if [[ "x${dist}" == "xwheezy" || "x${dist}" == "xprecise" ]]; then
        cc="/usr/bin/clang"
        cxx="/usr/bin/clang++"
    fi

    echo "CC=${cc} CXX=${cxx}"
}


#------------------------------------------------------------
#
# ex: base_arguments precise i386
#
# returns a string with arguments to sbuild that all build
# runs will use
#
#------------------------------------------------------------
function base_arguments() {
    local dist=$1
    local arch=$2
    local parallel_jobs=$(nproc)

    declare -a sbuild_args

    sbuild_args+=("--dist=${dist}")
    sbuild_args+=("--arch=${arch}")
    sbuild_args+=("--apt-update")
    sbuild_args+=("--apt-upgrade")
    sbuild_args+=("-j${parallel_jobs}")

    echo -n $(IFS=" "; echo "${sbuild_args[*]}")
}


#------------------------------------------------------------
#
# ex: additional_arguments precise i386
#
# returns a string with arguments to sbuild that may be
# dependent on the distro / architecture combo provided
#
#------------------------------------------------------------
function additional_arguments() {
    local dist=$1
    local arch=$2

    declare -a sbuild_args

    if [ "x${dist}" == "xwheezy" ]; then
        sbuild_args+=("--chroot-setup-commands=\"apt-get -y install curl apt-transport-https ca-certificates\"")
        sbuild_args+=("--chroot-setup-commands=\"echo 'deb https://deb.nodesource.com/clang-3.4 wheezy main' >> /etc/apt/sources.list\"")
        sbuild_args+=("--chroot-setup-commands=\"curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -\"")
        sbuild_args+=("--chroot-setup-commands=\"apt-get update\"")
        sbuild_args+=("--chroot-setup-commands=\"apt-get -y install clang-3.4\"")
    fi

    if [ "x${dist}" == "xprecise" ]; then
        sbuild_args+=("--chroot-setup-commands=\"apt-get -y install clang-3.4\"")
    fi

    echo -n $(IFS=" "; echo "${sbuild_args[*]}")
}


#------------------------------------------------------------
#
# ex: sbuild_cmd precise i386
#
# returns a string with the full build command to run a
# build
#
#------------------------------------------------------------
function sbuild_cmd() {
    local cc_vars=$(compiler_vars $1)
    local base=$(base_arguments $1 $2)
    local additional=$(additional_arguments $1 $2)
    echo "${cc_vars} sbuild ${base} ${additional}"
}
