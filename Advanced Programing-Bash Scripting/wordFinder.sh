#!/bin/bash
 
 #BASH script for assignment 1 

#stores possebility of ending the script.
#0-keep going, 1-end it
end=0

#valid min number of arguments
if(( $#<3 )); then 
	>&2 echo "Number of parameters received : "$# 
	echo "Usage : wordFinder.sh <valid file name> [More Files] ... <char> <length>"
	exit 1

fi

#get the char argument and convert to lowercase
char=${@: -2:1}
char="${char,}"

#minimum letters To look for in the files
minlettersTolookFor=${*: -1:1}

#valid char
if [[ $char != [0-9a-zA-z] ]]; then
	>&2 echo "Only one char needed : "$char
	end=1
fi

#valid number letters To look for in the files
if (( $minlettersTolookFor+0 <= 0 )); then
	>&2 echo "Not a positive number : "$minlettersTolookFor
	end=1
fi

#if the validation didnt achived then we send the right format and end the script
if (( end == 1 )); then
	echo "Usage : wordFinder.sh <valid file name> [More Files] ... <char> <length>"
	exit 1
fi

#List that will store all the files
myfilelist=()

#loop over all the arguments   
cnt=0
for i in $@;
do
	#pass the last two args
	if (( $# - cnt == 2 )); then
    	break 
    fi

    #valid file path
    if [ ! -f "$i" ]; then
   		>&2 echo "File does not exist : "$i
    end=1
	fi

	#add to file list
	myfilelist+=($i)

	#conter
	let cnt++
done

#if the validation of files didnt achived then we send the right format and end the script
if (( end == 1 )); then
	echo "Usage : wordFinder.sh <valid file name> [More Files] ... <char> <length>"
	exit 1
fi

#combine all the words from each file by the right spartion in long_words 
for i in "${!myfilelist[@]}"
do
	long_words+=$(cat "${myfilelist[$i]}" | tr -cs 'a-zA-Z0-9' '[\n*]' | grep '^[a-zA-Z0-9]*$') 
done

#counting with awk on long_words for each word that start with char and with the minimum number of letters To look for in each word
#then sort it and then print it with piping 
awk -v char=$char -v minlettersTolookFor=$minlettersTolookFor '{
		for(i=1;i<=NF;i++)
		{ 
			$i = tolower($i)
			if(substr($i,0,1)==char && length($i) >= minlettersTolookFor)
			{
				a[$i]++
			}
		}

	} 

	END {for(k in a) print a[k],k}' <<< $long_words | sort -n
