grep nix grep_excercise.txt
grep 'hello world' grep_excercise.txt
grep -n nix grep_excercise.txt # show line nubers
grep os grep_excercise.txt
grep -i os grep_excercise.txt # ignore case sensitive
cat grep_excercise.txt | grep os
grep tech grep_excercise.txt
grep ^tech grep_excercise.txt # pattern at the beginning of the line
grep x$ grep_excercise.txt # words end with a particular letter

egrep '^(l|o)' grep_excercise.txt
egrep '^[l-u]' grep_excercise.txt
egrep -c mellon grep_excercise.txt
