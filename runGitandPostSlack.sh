#!/bin/bash
set -eu

zip -r TR$DATE.zip $LATEST

node runPostSlackFile TR$DATE.zip

echo "git Operation Start -----"
git fetch

git add $TESTRESULT
git commit -m "$DATE"
git push origin HEAD
echo "git Operation End -----"

