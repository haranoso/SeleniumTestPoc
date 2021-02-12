#!/bin/bash
set -eu


echo "Test Start -----"
# ローカルで動かす場合は前回の結果を移動する
if [ -n "$(ls $LATEST)" ]; then
    if [ -n "$(ls $OLD)" ]; then
        rm $OLD/*
    fi
    mv $LATEST/* $OLD
fi
node runTest.js chrome $LATEST
echo "Test End -----"
