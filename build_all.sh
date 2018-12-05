#!/bin/sh
for f in ./testcase/*.c
do
	#echo ${f:1}
	bash ./build_test.sh $f
done
