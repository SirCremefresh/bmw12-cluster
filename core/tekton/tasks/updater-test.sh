#!/bin/usr/env bash

cd "../../../"

#changedProjects=$(
#  git diff --name-only 6a20c47e1ea0ead16e302a69a37591e5a1bf3754 16e995730c92be68bf034cb17e11f712cbface94 |
#    grep -e '^apps' |
#    awk -F'/' '{print $2}' |
#    sort |
#    uniq
#)

secretsLoaded="false"
function load_private_key() {
  if [ "${secretsLoaded}" == "false" ]; then
    echo "load_secrets"
    secretsLoaded="true"
  fi
}

function decrypt_secrets() {
  secretFiles=$1
  for secretFile in $secretFiles; do
    echo "Decrypting file: ${secretFile}"
    echo "${PASSPHRASE}" | PASSPHRASE="${PASSPHRASE}" gpg --batch \
    --pinentry-mode loopback --command-fd 0 -r donato@wolfisberg.dev \
    -d "${secretFile}" > "${secretFile}.plain-yaml"
  done
}

function apply_project() {
  project=$1
  echo "Working on $project"

  if ! cd "apps/${project}"; then
    echo "Project does not exist"
    return
  fi

  bmw12ApplicationJson=$(yq r --tojson bmw12-application.yaml)

  namespace=$(echo "${bmw12ApplicationJson}" | jq --raw-output ".name")
  valuesFiles=()

  values=$(echo "${bmw12ApplicationJson}" | jq ".values")
  if [ "${values}" != "null" ]; then
    valuesFiles+=("$(echo "${values}" | jq --raw-output ".[]")")
  fi

  valuesFiles+=(bmw12-application.yaml)

  secrets=$(echo "${bmw12ApplicationJson}" | jq ".secrets")
  if [ "${secrets}" != "null" ]; then
    load_private_key
    echo "Decrypting Secrets"
    secretFiles=$(echo "${secrets}" | jq --raw-output ".[]")
    decrypt_secrets "${secretFiles}"
    valuesFiles+=("$(echo "${secretFiles}" | awk '{print $1".plain-yaml"}')")
  fi

  echo "${valuesFiles[@]::${#valuesFiles[@]}-1}"
  valuesFilesArgument=""
  for valuesFile in "${valuesFiles[@]::${#valuesFiles[@]}-1}"; do
    valuesFilesArgument+="-f ${valuesFile} "
  done
  valuesFilesArgument+="-f ${valuesFiles[-1]}"

  eval "helm upgrade --install -n ${namespace} ${valuesFilesArgument} ${project} ."

  cd "../../"
}

load_private_key
load_private_key
load_private_key
load_private_key

#for project in $changedProjects; do
#  apply_project "${project}"
#done
