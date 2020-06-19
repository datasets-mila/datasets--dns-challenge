#!/bin/bash

# This script is meant to be used with the command 'datalad run'

cd DNS-Challenge/

git lfs install --skip-smudge
git lfs track "*.wav"
git add .gitattributes

git lfs fetch
git lfs pull

cd ..

rm files_count.stats
for dir in DNS-Challenge/datasets/*/
do
	echo $(find $dir -type f | wc -l; echo $dir) >> files_count.stats
done

du -s DNS-Challenge/datasets/*/ > disk_usage.stats
