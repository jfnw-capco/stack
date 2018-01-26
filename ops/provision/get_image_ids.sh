#!/bin/bash

FILES=${1}/*.id

OUTPUT="{"
for FILE in $FILES
do
	if [ ! $OUTPUT == "{" ]; then
		OUTPUT="${OUTPUT},"
	fi 
	WE="${FILE%.*}"
	OUTPUT="${OUTPUT}${WE##*/}=$(cat $FILE)"
done

echo "${OUTPUT}}" >>  ${1}/image.ids