#!/bin/bash

end=0

if(( $#<3 )); then 
	>&2 echo "Number of parameters received : "$# 
	exit 1

fi

char=${@: -2:1}
char="${char,}"
minWordsTolookFor=${*: -1:1}


if [[ $char != [0-9a-zA-z] ]]; then
	>&2 echo "Only one char needed : "$char
	end=1
fi

if (( $minWordsTolookFor+0 <= 0 )); then
	>&2 echo "Not a positive number : "$minWordsTolookFor
	end=1
fi

if (( end == 1 )); then
	echo "Usage : wordFinder.sh <valid file name> [More Files] ... <char> <length>"
	exit 1
fi

mylist=()
   
cnt=0
for i in $@;
do
	if (( $# - cnt == 2 )); then
    	break 
    fi
    if [ ! -f "$i" ]; then
   		>&2 echo "File does not exist : "$i
    end=1
	fi
	mylist+=($i)
	let cnt++
done

if (( end == 1 )); then
	echo "Usage : wordFinder.sh <valid file name> [More Files] ... <char> <length>"
	exit 1
fi


for i in "${!mylist[@]}"
do
	long_words+=$(cat "${mylist[$i]}" | tr -cs 'a-zA-Z0-9' '[\n*]' | grep '^[a-zA-Z0-9]*$') 
done

awk -v char=$char -v minWordsTolookFor=$minWordsTolookFor '{
		for(i=1;i<=NF;i++)
		{ 
			$i = tolower($i)
			if(substr($i,0,1)==char && length($i) >= minWordsTolookFor)
			{
				a[$i]++
			}
		}

	} 

	END {for(k in a) print a[k],k}' <<< $long_words | sort -n
