#!/bin/sh

# Author : Elva
# Script follows here:

# Decision Making Example
a=10
b=20
if [ $a == $b ]
then
	echo "a is equal to b"
elif [ $a -gt $b ]
then
	echo "a is greater than b"
elif [ $a -lt $b ]
then
	echo "a is less than b"
else
	echo "None of the condition met"
fi

# Shell Loops
for FILE in $HOME/.*
do
	echo $FILE
done

a=0
until [ ! $a -lt 10 ]
do
	echo $a
	a=`expr $a + 1`
done

# Functions
Hello () {
	echo "Hello World $1 $2"
	return 10
}
Hello Elva Wang
ret=$?
echo "return value is $ret"

# Case Statement Example
option="${1}"
case ${option} in
	-f) FILE="${2}"
		echo "File name is $FILE"
		;;
	-d) DIR="${2}"
		echo "Dir name is $DIR"
		;;
	*)
		echo "`basename ${0}`:usage: [-f file] | [-d directory]"
		exit 1
		;;
esac

select DRINK in tea cofee water juice appe all none
do
	case $DRINK in
		tea | cofee | water | all)
			echo "go to canteen"
			;;
		juice | appe)
			echo "available at home"
			;;
		none)
			break
			;;
		*)
			echo "error: invalid selection"
			;;
	esac
done


