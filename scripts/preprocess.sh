#!/bin/bash

# This script is meant to be used with the command 'datalad run'

pip install -r scripts/requirements_preprocess.txt
ERR=$?
if [ $ERR -ne 0 ]; then
   echo "Failed to install requirements: pip install: $ERR"
   exit $ERR
fi

mkdir -p preprocess/

while read line
do
	case ${line} in
		noise_dir:*)
		printf "noise_dir: $(git remote get-url origin)/DNS-Challenge/datasets/noise\n"
		;;
		speech_dir:*)
		printf "speech_dir: $(git remote get-url origin)/DNS-Challenge/datasets/clean\n"
		;;
		noisy_destination:*)
		printf "noisy_destination: preprocess/noisy\n"
		;;
		clean_destination:*)
		printf "clean_destination: preprocess/clean\n"
		;;
		noise_destination:*)
		printf "noise_destination: preprocess/noise\n"
		;;
		log_dir:*)
		printf "log_dir: preprocess/logs\n"
		;;
		*)
		printf "${line}\n"
		;;
	esac
done < DNS-Challenge/noisyspeech_synthesizer.cfg > preprocess/noisyspeech_synthesizer.cfg

# --cfg is intepreted as relative to the file noisyspeech_synthesizer_multiprocessing.py
python DNS-Challenge/noisyspeech_synthesizer_multiprocessing.py --cfg ../preprocess/noisyspeech_synthesizer.cfg 1>> preprocess.out 2>> preprocess.err

rm files_count.stats
for dir in preprocess/*/
do
	echo $(find $dir -type f | wc -l; echo $dir) >> files_count.stats
done

du -s preprocess/*/ > disk_usage.stats
