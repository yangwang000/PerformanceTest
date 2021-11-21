#!/bin/sh

# word frequency
cat grep_excercise.txt | tr -s ' ' '\n' | sort | uniq -c | sort -r | awk '{ print $2, $1 }'

# valid phone numbers
grep -e "^\([0-9]\{3\}-\|([0-9]\{3\}) \)[0-9]\{3\}-[0-9]\{4\}$" phone_numbers.txt
grep -P '^(\d{3}-|\(\d{3}\) )\d{3}-\d{4}$' phone_numbers.txt
sed -n -r '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/p' phone_numbers.txt
awk '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/' phone_numbers.txt

# output tenth line
# solution 2
awk 'FNR == 10 {print }' file.txt
# or
awk 'NR == 10' file.txt
# solution 3
sed -n 10p file.txt
# solution 4
tail -n+10 file.txt | head -1
# solution 1
cnt=0
while read line && [ $cnt -le 10 ]; do
	let 'cnt = cnt + 1'
	if [ $cnt -eq 10 ]; then
		echo $line
		exit 0
	fi
done < file.txt

