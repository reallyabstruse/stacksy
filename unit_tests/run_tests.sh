#!/bin/bash
compile_and_run() {
	rm -f $1.{asm,o,out}
	python3 ../main.py -i "$1.stacksy" -o "$1.asm" && nasm -f elf64 "$1.asm" && gcc "$1.o" -o "$1.out" && "./$1.out"
}

want_create=false
i=0
for f in *.stacksy
do
	filename="${f%.*}"
	EXPECTED="$filename.expected";
	if ! test -f "$EXPECTED"; then
		if [ "$want_create" = false ]; then
			read -p "$EXPECTED does not exist, create missing files? [yN]" yn
			case $yn in 
				[Yy]* ) want_create=true;;
				* ) exit;;
			esac
		fi
		(compile_and_run $filename) > $EXPECTED
	fi
	if ! diff -a -u $EXPECTED <(compile_and_run $filename); then
		echo "incorrect output for $f"
		break
	fi
	echo "Passed $f"
	i=$((i+1))
done

echo "Passed $i tests"