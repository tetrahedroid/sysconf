#!/bin/bash

# bash appender.sh filename pattern appendedstr

# 引数の数があわない時は止める
[ $# -eq 3 ] || (echo "Check the arguments."; exit 1)

# バックアップのファイル名をさがす
original=$1
n=1
while [ -e $original.$n ]; do n=`expr $n + 1`; done
backup=$original.$n

# 置き換え
cp $original $backup
sed -e "s!\($2.*\)!\1 $3!" < $backup > $original
