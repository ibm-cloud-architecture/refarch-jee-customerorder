#!/usr/bin/env bash

##############################################################################
##
##  Wrapper script to manually pull SQL & init database
##
##  Parameters:
##  - DB2_HOST
##  - DB2_PORT        (Defaults to 50000)
##  - DB2_USER        (Defaults to db2inst1)
##  - DB2_PASSWORD
##
##  Environment Variables:
##  - COS_GIT_ORG     (Defaults to ibm-cloud-architecture)
##  - COS_GIT_BRANCH  (Defaults to liberty)
##############################################################################

# Terminal Colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'
coffee=$'\xE2\x98\x95'
coffee3="${coffee} ${coffee} ${coffee}"

function error_check {
  if [ ${?} -ne 0 ]; then
    echo "${red}${1}${end}"
    exit 1
  fi
}

# set environment
git_org=${COS_GIT_ORG:-ibm-cloud-architecture}
git_branch=${COS_GIT_BRANCH:-liberty}
file_list=(
  createOrderDB.sql
  InventoryDdl.sql
  InventoryData.sql
  initialDataSet.sql
)

CURL_BIN=$(which curl)
if [ ${?} -ne 0 ]; then
  echo "${red}'curl' not found on your local system.${end} Please install git and try again."
  exit 1
fi

DB2_BIN=$(which db2)
if [ ${?} -ne 0 ]; then
  echo "${red}'db2' not found on your local system.${end} Please install git and try again."
  exit 1
fi

# clone repos
#currepo=$(git rev-parse --show-toplevel|awk -F '/' '{print $NF}')
echo "${grn}Downloading database files from ${git_org}/refarch-jee-customerorder branch:${origin_branch}...${end}"
base_url="https://raw.githubusercontent.com/${git_org}/refarch-jee-customerorder/${git_branch}/Common"

WORKING_DIR=bootstrap-data
rm -rf ${WORKING_DIR}
mkdir ${WORKING_DIR}

for file in ${file_list[@]}
do
  file_url="${base_url}/${file}"
  printf "\n\n${grn}Downloading ${file_url}...\n${end}"
  ${CURL_BIN} --output ${WORKING_DIR}/${file} --progress-bar ${file_url}
done

printf "\n${grn}Successfully downloaded required database files from branch:${git_branch}\n${end}"

printf "\n${grn}Attempting to create 'ORDERDB'\n${end}"
${DB2_BIN} create database ORDERDB
error_check "ORDERDB creation failed."

${DB2_BIN} connect to ORDERDB
error_check "Failed to connect to ORDERDB."

${DB2_BIN} -tvf Common/createOrderDB.sql
error_check "ORDERDB SQL execution failed."

#db2 create database INDB
#db2 connect to INDB
#db2 -tf Common/InventoryDdl.sql
#db2 -tf Common/InventoryData.sql
