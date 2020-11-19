#!/bin/bash

# Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0


usage() {
   echo
   echo "$0"
   echo "Make a package for offline installation of a Helm chart"
   echo
   echo "Arguments:"
   echo "-c             Create an offline bundle with chart argument"
   echo "-p             Prepare this bundle for installation with registry argument"
   echo "               Supply the registry name/path which will hold the images"
   echo "               For example: my.registry.com:5000/dell/karavi-observability"
   echo "-h             Displays this information"
   echo
   echo "Exactly one of '-c' or '-p' needs to be specified"
   echo
}

status() {
  echo
  echo "*"
  echo "* $@"
  echo
}

REGISTRY=""
CHARTNAME=""
HELMBACKUPDIR="helm-original"
HELMDIR="helm"
IMAGEDIR="images"
HELMREPO="https://github.com/dell/helm-charts"
CHARTPREFIX="dell/"

create_bundle() {

    # set the distribution directory and file based on the name of the chart
    DISTDIR="offline-${CHARTNAME#$CHARTPREFIX}-bundle"
    DISTFILE="${DISTDIR}.tar.gz"

    # remove the distribution directory in case it already exists and create all required sub-directories
    rm -rf ${DISTDIR}
    mkdir -p ${DISTDIR} ${DISTDIR}/${HELMBACKUPDIR} ${DISTDIR}/${IMAGEDIR}

    status "Adding Helm repository ${HELMREPO}"
    run_command "helm repo add dell ${HELMREPO}"

    status "Downloading Helm chart ${CHARTNAME} to directory $(pwd)/${DISTDIR}/${HELMBACKUPDIR}"
    run_command "helm pull ${CHARTNAME} --untar --untardir ${DISTDIR}/${HELMBACKUPDIR}"

    # search for all images from the values.yaml files that were contained in the Helm chart
    find ${DISTDIR}/${HELMBACKUPDIR} -name "values.yaml" -type f -exec egrep -oh "image: (.+)" {} \; | awk '{print $2}' > ${DISTDIR}/images.txt

    status "Downloading and saving Docker images"
    while read line; do
        echo "   $line"
        run_command "${DOCKER} pull ${line}"
        IMAGEFILE=$(echo "${line}" | sed 's|[/:]|-|g')
        run_command "${DOCKER} save -o ${DISTDIR}/${IMAGEDIR}/${IMAGEFILE}.tar ${line}"
    done < ${DISTDIR}/images.txt

    # copy this script into the distribution directory
    cp $0 ${DISTDIR}

    status "Compressing ${DISTFILE}"
    tar -czf ${DISTFILE} ${DISTDIR}
}

install_bundle() {
    # make a helm directory that will store the modified helm chart with updated image names
    rm -rf ${HELMDIR}
    cp -r ${HELMBACKUPDIR} ${HELMDIR}
    status "Loading, tagging, and pushing Docker images to registry ${REGISTRY}"
    while read line; do
        local IMAGEFILE=$(echo "${line}" | sed 's|[/:]|-|g')
        local NEWIMAGENAME="${REGISTRY}${line##*/}"
        echo "   $line -> ${NEWIMAGENAME}"

        # replace the image names in the helm directory with the new names based on the provided registry URL
        find ${HELMDIR} -type f -exec sed -i "s|$line|$NEWIMAGENAME|g" {} \;

        run_command "${DOCKER} load --input ${IMAGEDIR}/${IMAGEFILE}.tar"
        run_command "${DOCKER} tag ${line} ${NEWIMAGENAME}"
        run_command "${DOCKER} push ${NEWIMAGENAME}"
    done < images.txt
}

run_command() {
  CMDOUT=$(eval "${@}" 2>&1)
  local rc=$?

  if [ $rc -ne 0 ]; then
    echo
    echo "ERROR"
    echo "Received a non-zero return code ($rc) from the following comand:"
    echo "  ${@}"
    echo
    echo "Output was:"
    echo "${CMDOUT}"
    echo
    echo "Exiting"
    exit 1
  fi
}


while getopts "c:p:h" opt; do
  case $opt in
    c)
      CREATE="true"
      CHARTNAME="${OPTARG}"
      ;;
    p)
      PREPARE="true"
      REGISTRY="${OPTARG}"
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ "${CREATE}" == "${PREPARE}" ]; then
  usage
  exit 1
fi

if [ "${CREATE}" == "true" ]; then
  if [ "${CHARTNAME}" == "" ]; then
    usage
    exit 1
  fi
  if [[ $CHARTNAME != $CHARTPREFIX* ]]; then
    echo "Chart name must begin with '${CHARTPREFIX}' (ex: dell/karavi-observability)"
    exit 1
  fi
fi

if [ "${PREPARE}" == "true" ]; then
  if [ "${REGISTRY}" == "" ]; then
    usage
    exit 1
  fi
  if [ "${REGISTRY: -1}" != "/" ]; then
    REGISTRY="${REGISTRY}/"
  fi
fi

DOCKER=$(which docker 2>/dev/null)
if [ "${DOCKER}" == "" ]; then
  echo "Unable to find docker in $PATH"
  exit 1
fi

# create a bundle
if [ "${CREATE}" == "true" ]; then
  create_bundle
fi

# prepare a bundle for installation
if [ "${PREPARE}" == "true" ]; then
  install_bundle
fi

echo

exit 0
