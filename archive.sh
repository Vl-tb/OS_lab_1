#!/bin/bash
os="$(uname -s)"
case "${os}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac
esac

pth='*.*'
zip_pth="./"
zip_pth_nm="${PWD##*/}-"
days=1
remove=0

while getopts "p:d:r" option; do
    case ${option} in
        p)
            # echo ${OPTARG}
            pth="${OPTARG}/*.*"
            zip_pth="${OPTARG}/"
            zip_pth_nm="${OPTARG}-";;
            # echo ${zip_pth};;
        d)
            days=${OPTARG};;
            # echo ${days};;
        r)
            remove=1;;
            # echo ${remove};;
    esac
done

files=""

if [ ${machine} == Mac ]; then
    for file in ${pth}
    do
        ctime=$(GetFileInfo -d ${file})
        ctime=$(gdate -d "${ctime}" +"%s")
        curtime=$(date +%s)
        let diff=${curtime}-${ctime}
        let threshold=${days}*86400
        if [ ${diff} -lt ${threshold} ]; then
            files="${files} ${file}"
        fi
    done
else
    echo Dasha implement pls
    exit 0;
fi
now=$(date +"%Y-%m-%d-%H-%M-%S")

if [ ${remove} == 1 ]; then
    zip -m ${zip_pth}${zip_pth_nm}${now}.zip ${files}
else
    zip ${zip_pth}${zip_pth_nm}${now}.zip ${files};
fi
