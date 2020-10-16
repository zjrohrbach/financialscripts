temp_csv_file=~/.financialscripts/visualizing/csv_file.csv
temp_graph_file=~/.financialscripts/visualizing/graph_file.png

#function to turn csv into tab-deliminated file, stripped of commas and $'s
csv_to_tabbed () {
	sed -i '' 's/","/	/g' $1	# turn , to \tab
	sed -i '' 's/,//g' $1 		# turn 1,000 to 1000
	sed -i '' 's/\$//g' $1 		# turn $1000 to 1000 (delete $)
	sed -i '' 's/"//g' $1 		# strip quotation marks
	sed -i '' 's/-//g' $1 		# strip negatives
}

#function to use datamash to transpose file and then spit it out into same file
tabbed_transpose () {
	cat $1 | datamash --no-strict transpose > newfile.txt
	cat newfile.txt > $1
	rm newfile.txt
}

#run both csv_to_tabbed() and tabbed_transpose() in order 
#to make a file friendly for gnuplot
gnuplot_friendly () {
	csv_to_tabbed $1
	tabbed_transpose $1
}

#decide what method to display image.  Either open or cat (to be piped into imgcat)
display_function () {
	open $1
	#cat $1
}
