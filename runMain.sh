#!/bin/bash
set -eu

echo $INPUT_SLACK_TOKEN
# export SLACK_TOKEN=$INPUT_SLACK_TOKEN
# export SLACK_CHANNEL=$INPUT_SLACK_CHANNEL
# export SLACK_SECRET_KEY=$INPUT_SLACK_SECRET_KEY
# export SLACK_POST_IMAGE=$INPUT_SLACK_POST_IMAGE
# export SLACK_POST_TEXT=$INPUT_SLACK_POST_TEXT
# export DEBUG=$INPUT_DEBUG
# export GIT_EMAIL=$INPUT_GIT_EMAIL
# export GIT_USERNAME=$INPUT_GIT_USERNAME
# export SFDX_AUTH_URL=$INPUT_SFDX_AUTH_URL

# export TESTRESULT="./TestResult/"
# export CHECKRESULT="./checkResult"
# export DIFF="./DiffResult/"

# export OLD=$TESTRESULT"old"
# export LATEST=$TESTRESULT"latest"

# export DATE=`date "+%Y%m%d_%H%M%S"`


# # SETUP SFDX
# echo SETUP SFDX
# echo $SFDX_AUTH_URL > ./key.auth
# sfdx config:set defaultusername=`sfdx for/ce:auth:sfdxurl:store -f ./key.auth |cut -d ' ' -f3`

# # SETUP GIT
# echo SETUP GIT
# git config --global user.email $GIT_EMAIL
# git config --global user.name $GIT_USERNAME

# # START TEST
#  ./runTest.sh
#  ./runGitandPostSlack.sh 

# # START CHECK
# ./runCheck.sh 

