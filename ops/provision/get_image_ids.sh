#!/bin/bash

FILES=${1}/*.id

OUTPUT="{"
for f in $FILES
do

	if [ ! $OUTPUT == "{" ]; then
		OUTPUT="${OUTPUT},"
	fi 
	WE="${f%.*}"
	OUTPUT="${OUTPUT}${WE##*/}=$(cat $f)"
done

echo "${OUTPUT}}" >>  ${1}/image.ids