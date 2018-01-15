#!/usr/bin/env bash

##############################################################################
##  Wrapper script to manually pull SQL & init database
##
##  Environment Variables:
##  - COS_GIT_ORG     (Defaults to ibm-cloud-architecture)
##  - COS_GIT_BRANCH  (Defaults to liberty)
##  - ORDERDB_NAME    (Defaults to ORDERDB)
##############################################################################

##############################################################################
## Setup
##############################################################################

#Environment variable set by the initial container creation
DB2_USER=${DB2INSTANCE:-db2inst1}

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
    echo "\n${red}${1}${end}\n"
    exit 1
  fi
}

# set environment
git_org=${COS_GIT_ORG:-ibm-cloud-architecture}
git_branch=${COS_GIT_BRANCH:-liberty}
file_list=(
  createOrderDB.sql
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

##############################################################################
## Script
##############################################################################

echo "\n${grn}Downloading database files from ${git_org}/refarch-jee-customerorder branch:${origin_branch}...${end}\n"
base_url="https://raw.githubusercontent.com/${git_org}/refarch-jee-customerorder/${git_branch}/Common"

WORKING_DIR=bootstrap-data
rm -rf ${WORKING_DIR}
mkdir ${WORKING_DIR}

for file in ${file_list[@]}
do
  file_url="${base_url}/${file}"
  printf "\n${grn}Downloading ${file_url}...${end}\n"
  ${CURL_BIN} --output ${WORKING_DIR}/${file} --progress-bar ${file_url}
done

printf "\n${grn}Successfully downloaded required database files from branch:${git_branch}${end}\n"

local_order_db_name=${ORDERDB_NAME:-ORDERDB}
printf "\n${grn}Attempting to connect to '${local_order_db_name}'${end}\n"
${DB2_BIN} connect to ${local_order_db_name}
error_check "Failed to connect to ${local_order_db_name}."

printf "\n${grn}Attempting to create schema for '${local_order_db_name}'${end}\n"
${DB2_BIN} -tvf ${WORKING_DIR}/createOrderDB.sql

printf "\n${grn}Attempting to load initial data for '${local_order_db_name}'${end}\n"
${DB2_BIN} -tvf ${WORKING_DIR}/initialDataSet.sql

printf "\n${grn}Database '${local_order_db_name}' bootstrapped for application use.${end}\n"
