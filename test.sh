#!/bin/bash

HELM_ARGS=""
NAMESPACE="dev-hd"
RELEASE_FILTER='^(?!hd-index-page-generator|dev-core).*$'
BRANCH_FILTER=""
BRANCH_HELM_PROPERTY=".indexPage.branch"
MAX_AGE_IN_DAYS="19"

set -e

echo "Filtered helm releases by name:"
HELM_RELEASES_JSON=$(helm list $HELM_ARGS -n "${NAMESPACE}" -o json | jq -r --arg REG ${RELEASE_FILTER} '.[] | select(.name|test($REG))' | jq -s '.')
HELM_RELEASES=$(echo "${HELM_RELEASES_JSON}" | jq -r '.[].name')
echo -n "${HELM_RELEASES}" > /tmp/HELM_RELEASES

if [ -n "${HELM_RELEASES}" ]; then
    echo "${HELM_RELEASES}"
fi
echo

if [ ! -z "${BRANCH_FILTER}" ] && [ -n "${HELM_RELEASES}" ]; then
  echo "Filtered helm releases by branch $BRANCH_FILTER:"
  echo -n > /tmp/HELM_RELEASES
  for RELEASE in $HELM_RELEASES
  do
    set +e
    HELM_VALUES_JSON=$(helm get values $HELM_ARGS -n "${NAMESPACE}" --all -o json "${RELEASE}")
    BRANCH=$(echo "${HELM_VALUES_JSON}" | jq -r --arg BRANCH_HELM_PROPERTY "${BRANCH_HELM_PROPERTY}" '$BRANCH_HELM_PROPERTY')
    set -e

    if [ "$BRANCH" == "$BRANCH_FILTER" ]; then
      echo "$RELEASE"
      echo -e "$RELEASE" >> /tmp/HELM_RELEASES
    fi
  done
  echo
fi

HELM_RELEASES=$(cat /tmp/HELM_RELEASES)

if [ ! -z "${MAX_AGE_IN_DAYS}" ] && [ -n "${HELM_RELEASES}" ]; then
  echo "Filtered helm releases by date:"
  echo -n > /tmp/HELM_RELEASES
  for RELEASE in $HELM_RELEASES
  do
    LAST_UPGRADE=$(echo "${HELM_RELEASES_JSON}" | jq -r ". | map(select(.name == \"$RELEASE\"))[0].updated" | cut -d ' ' -f1-2)
    LAST_UPGRADE_DATE=$(date -d "${LAST_UPGRADE}" +%s)
    COMPARE_DATE=$(date -d "now - ${MAX_AGE_IN_DAYS} days" +%s)

    if [ "${LAST_UPGRADE_DATE}" -le "${COMPARE_DATE}" ]; then
      echo "$RELEASE"
      echo -e "$RELEASE" >> /tmp/HELM_RELEASES
    fi
  done
fi
