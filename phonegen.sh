#!/bin/bash

# fill in your prefixes & filename
prefixes=( 415201 415202 415203 )
filename=phonegen.txt

# our cleanup for SIGTERM
trap ctrl_c INT

function ctrl_c() {
	printf "user intervention\n"
	printf "cleaning up unfinished files...\n"
	rm -rf ./tmp ./$filename
	exit
}

# check that crunch is installed
if hash crunch 2>/dev/null; then
	printf "crunch has been located\n"
else
	printf "apt install crunch\n"
	exit
fi

# create tmp folder
mkdir ./tmp

# remove old file if existing
if [ -e ./$filename ]
then
	printf "deleting old file $filename\n"
	rm -f ./$filename
fi

# run crunch for each phone prefix
for prefix in "${prefixes[@]}"
do
	:
	printf "creating list $prefix.txt\n"
	crunch 10 10 -t $prefix%%%% -o ./tmp/$prefix.txt &>/dev/null
done


# then parse into one file
for prefix in "${prefixes[@]}"
do
	:
	printf "merging list $prefix.txt into $filename\n"
	cat ./tmp/$prefix.txt >> ./$filename
done

# then remove the old files
for prefix in "${prefixes[@]}"
do
	:
	printf "removing old file $prefix.txt\n"
	rm ./tmp/$prefix.txt
done

# remove the tmp folder
printf "removing the ./tmp directory\n"
rm -rf ./tmp

# complete
printf "complete, look at ./$filename\n"