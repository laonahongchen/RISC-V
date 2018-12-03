#!/bin/sh
for f in ./testcase/*.c
do
	bash ./build_test.sh f
done
