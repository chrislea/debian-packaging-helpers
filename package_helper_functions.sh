#!/bin/bash

#------------------------------------------------------------
# functions to extract info about a package give the filename
#------------------------------------------------------------

#------------------------------------------------------------
# is_package_file
#
# is this a .deb or a .dsc file?
#
#    is_package_file nodejs-dbg_6.2.2-1nodesource1~xenial1.dsc
#
# returns
#
#    true
#------------------------------------------------------------
function is_package_file {
    local filename=${1}
    local file_extension=${filename:(-4)}

    if [[ ${file_extension} == ".dsc" || ${file_extension} == ".deb" ]]; then
        echo "true"
    else
        echo "false"
    fi
}


#------------------------------------------------------------
# is_deb
#
# is this a .deb file?
#
#    is_deb nodejs-dbg_6.2.2-1nodesource1~xenial1.dsc
#
# returns
#
#    false
#------------------------------------------------------------
function is_deb {
    local filename=${1}
    local file_extension=${filename:(-4)}

    if [[ ${file_extension} == ".deb" ]]; then
        echo "true"
    else
        echo "false"
    fi
}


#------------------------------------------------------------
# is_dsc
#
# is this a .dsc file?
#
#    is_deb nodejs-dbg_6.2.2-1nodesource1~xenial1.dsc
#
# returns
#
#    true
#------------------------------------------------------------
function is_dsc {
    local filename=${1}
    local file_extension=${filename:(-4)}

    if [[ ${file_extension} == ".dsc" ]]; then
        echo "true"
    else
        echo "false"
    fi
}


#------------------------------------------------------------
# package_name
#
# return the name of the package.
#
#    package_name nodejs-dbg_6.2.2-1nodesource1~xenial1_armhf.deb
#
# returns
#
#    nodejs-dbg
#------------------------------------------------------------
function package_name {
    local filename=${1}
    echo $(echo ${filename} | cut -d'_' -f 1)
}


#------------------------------------------------------------
# package_version
#
# return the version of the package.
#
#    package_version nodejs-dbg_6.2.2-1nodesource1~xenial1_armhf.deb
#
# returns
#
#    6.2.2
#------------------------------------------------------------
function package_version {
    local filename=${1}
    echo $(echo ${filename} | sed "s/[^0-9.]\+\([0-9.]\+\).*/\1/")
}


#------------------------------------------------------------
# package_distro
#
# return the intended distribution of the package.
#
#    package_version nodejs-dbg_6.2.2-1nodesource1~xenial1_armhf.deb
#
# returns
#
#    xenial
#------------------------------------------------------------
function package_distro {
    local filename=${1}
    echo $(echo ${filename} | sed "s/.*\~\([a-zA-Z]\+\).*/\1/")
}


#------------------------------------------------------------
# package_arch
#
# return the architecture of the package.
#
#    package_arch nodejs-dbg_6.2.2-1nodesource1~xenial1_armhf.deb
#
# returns
#
#    armhf
#------------------------------------------------------------
function package_arch {
    local filename=${1}
    echo $(echo ${filename} | cut -d'_' -f 3 | sed "s/\..\+//")
}


#------------------------------------------------------------
# reprepro_cmd
#
# return the "correct" reprepro command based on the
# filename.
#
#    reprepro_cmd nodejs-dbg_6.2.2-1nodesource1~xenial1_armhf.deb
#
# returns
#
#    reprepro --basedir . --gnupghome /home/user/.gnupg --keepunreferencedfiles includedeb xenial nodejs-dbg_6.2.2-1nodesource1~xenial1_armhf.deb
#------------------------------------------------------------
function reprepro_cmd {
    local filename=${1}
    local basedir=${basedir:-"."}
    local gnupghome=${gnupghome:-"${HOME}/.gnupg"}
    local distro=$(package_distro ${filename})
    local include=""

    if [ "x$(is_deb ${filename})" == "xtrue" ]; then
        include="includedeb"
    elif [ "x$(is_dsc ${filename})" == "xtrue" ]; then
        include="includedsc"
    else
        echo "The file ${filename} doesn't appear to be a .deb or .dsc file... exiting..."
        exit 1
    fi

    echo "reprepro --basedir ${basedir} --gnupghome ${gnupghome} --keepunreferencedfiles ${include} ${distro} ${filename}"

}
