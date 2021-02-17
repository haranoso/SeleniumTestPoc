#!/bin/bash
set -eu

if [ -n "$(ls $DIFF)" ]; then
    rm $DIFF/*
fi

export DEBUG='false'

node runCheck $TESTRESULT $DIFF > $CHECKRESULT

export DEBUG='true'

cat $CHECKRESULT
node runPostSlack $CHECKRESULT

zip -r result.zip $DIFF
node runPostSlackFile result.zip
