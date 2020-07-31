#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Useage: `basename $0` version"
    exit 2
fi

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

testvercomp () {
    vercomp $1 $3
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $2 ]]
    then
        echo "FAIL: Expected '$2', Actual '$op'; Arg1 '$1', Arg2 '$2', Arg3 '$3'"
    else
        echo "Pass: '$1 $op $2'"
    fi
}

V=`python3 --version | cut -d' ' -f2`

testvercomp $V '<' $1

exit 0
