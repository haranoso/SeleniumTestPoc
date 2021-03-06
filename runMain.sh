#!/bin/bash
set -eu

# ローカルで実行する場合はここを有効にし適切に値を設定する
# export SLACK_SECRET_KEY='<Signing Secret>'
# export SLACK_TOKEN='<Bot User OAuth Access Token>'
# export SLACK_CHANNEL='<Channel ID>'

# export SFDX_AUTH_URL='<Sfdx Auth URL>'

# export SLACK_POST_IMAGE='true'
# export SLACK_POST_TEXT='true'
# export DEBUG='true'

export TESTRESULT="./TestResult/"
export CHECKRESULT="./checkResult"
export DIFF="./DiffResult/"

export OLD=$TESTRESULT"old"
export LATEST=$TESTRESULT"latest"

export DATE=`date "+%Y%m%d_%H%M%S"`


# SETUP SFDX
echo SETUP SFDX
echo $SFDX_AUTH_URL > ./key.auth
sfdx config:set defaultusername=`sfdx force:auth:sfdxurl:store -f ./key.auth |cut -d ' ' -f3`

# START TEST
 ./runTest.sh
 ./runGitandPostSlack.sh 

# START CHECK
./runCheck.sh 

