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

#one of my bank accounts puts a lot of unnecessary 
#gobbledygook prior to each transaction.  This function 
#gets rid of that gobbledygook.
function deal_with_sillybank() {  
	file_for_rules=$1
	temporary_file=~/temporary-sillybank-import.csv
	cat $import_file | sed 's/MERCHANT PURCHASE TERMINAL [0-9]* //g' | sed 's/POS PURCHASE TERMINAL [0-9]* //g' | cut -c -70 > $temporary_file
	run_hledger $temporary_file $file_for_rules
	rm $temporary_file 
}

#this following if statement needs to be copied for each bank that you have
if [ "$account" = 'bank-1' ]; then
	run_hledger $import_file ~/.financialscripts/hledger-rules/citi.csv
fi


#use this if statement if your bank needs the gobbledygook stripped out of it.
if [ "$account" = 'sillybank' ]; then
	deal_with_sillybank ~/.financialscripts/hledger-rules/lcb-joint.csv
fi


if [ "$import_file" = 'help' ]; then
	echo "USAGE: $0 import_file account"
fi
