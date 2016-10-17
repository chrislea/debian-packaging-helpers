#!/bin/bash

#------------------------------------------------------------
# functions to extract info about a package give the filename
#------------------------------------------------------------

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
#
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
#
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
#
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
#
#------------------------------------------------------------
function package_arch {
    local filename=${1}
    echo $(echo ${filename} | cut -d'_' -f 3 | sed "s/\.deb//")
}


exit 0
