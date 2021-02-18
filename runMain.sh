#!/bin/bash
set -eu

# export SLACK_TOKEN='<Slack BOT Oauth Token>'
# export SLACK_CHANNEL='<Slack Channel ID>'
# export SLACK_SECRET_KEY='<Signing Secret>'
# export SLACK_POST_IMAGE='false'
# export SLACK_POST_TEXT='false'
# export DEBUG='true'
# export GIT_EMAIL=''
# export GIT_USERNAME=''
# export SFDX_AUTH_URL=''

export TESTRESULT="./TestResult/"
export CHECKRESULT="./checkResult"
export DIFF="./DiffResult/"

export OLD=$TESTRESULT"old"
export LATEST=$TESTRESULT"latest"

export DATE=`date "+%Y%m%d_%H%M%S"`


# SETUP SFDX
echo SETUP SFDX
echo $SFDX_AUTH_URL > ./key.auth
sfdx config:set defaultusername=`sfdx for/ce:auth:sfdxurl:store -f ./key.auth |cut -d ' ' -f3`

# SETUP GIT
echo SETUP GIT
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USERNAME

# START TEST
 ./runTest.sh
 ./runGitandPostSlack.sh 

# START CHECK
./runCheck.sh 

