#!/bin/bash
import_file="$1"
account="$2"

function run_hledger() {
	file_to_copy=$1
	file_for_rules=$2
	cp $file_to_copy $file_for_rules
	hledger -f $file_for_rules print
	rm $file_for_rules
}

function deal_with_sillybank() {  #one of my bank accounts puts a lot of unnecessary gobbledygook prior to each transaction.  This function gets rid of that gobbledygook.
	file_for_rules=$1
	temporary_file=~/temporary-sillybank-import.csv
	cat $import_file | sed 's/MERCHANT PURCHASE TERMINAL [0-9]* //g' | sed 's/POS PURCHASE TERMINAL [0-9]* //g' | cut -c -70 > $temporary_file
	run_hledger $temporary_file $file_for_rules
	rm $temporary_file 
}

if [ "$account" = 'citi' ]; then
	run_hledger $import_file ~/.financialscripts/hledger-rules/citi.csv
fi

if [ "$account" = 'oldnatl-check' ]; then
	run_hledger $import_file ~/.financialscripts/hledger-rules/onb.csv
fi

if [ "$account" = 'oldnatl-sav' ]; then
	run_hledger $import_file ~/.financialscripts/hledger-rules/onb-s.csv
fi

if [ "$account" = 'lcb-e' ]; then
	deal_with_sillybank ~/.financialscripts/hledger-rules/lcb-e.csv
fi

if [ "$account" = 'lcb' ]; then
	deal_with_sillybank ~/.financialscripts/hledger-rules/lcb-joint.csv
fi

if [ "$account" = 'capone' ]; then
	run_hledger $import_file ~/.financialscripts/hledger-rules/capone.csv
fi

if [ "$import_file" = 'help' ]; then
	echo "USAGE: $0 import_file account"
fi
