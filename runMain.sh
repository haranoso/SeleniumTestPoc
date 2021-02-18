#!/bin/bash
set -eu


export TESTRESULT="./TestResult/"
export CHECKRESULT="./checkResult"
export DIFF="./DiffResult/"

export OLD=$TESTRESULT"old"
export LATEST=$TESTRESULT"latest"

export DATE=`date "+%Y%m%d_%H%M%S"`


# SETUP SFDX
echo SETUP SFDX
echo $SFDX_AUTH_URL_KEY@$SFDX_AUTH_URL_DOMAIN 
echo 'force://PlatformCLI::'$SFDX_AUTH_URL_KEY@$SFDX_AUTH_URL_DOMAIN > ./key.auth
sfdx config:set defaultusername=`sfdx force:auth:sfdxurl:store -f ./key.auth |cut -d ' ' -f3`

# SETUP GIT
echo SETUP GIT
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USERNAME

# START TEST
 ./runTest.sh
 ./runGitandPostSlack.sh 

# START CHECK
./runCheck.sh 

