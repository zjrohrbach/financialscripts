#!/bin/bash
source ~/.financialscripts/visualizing/inc/header.sh

hledger_expression="hledger -f $HLEDGER_FILE bal --auto -M -O csv --depth=2 expenses"

#generate data from hledger
#echo '"#"' > $temp_csv_file
eval $hledger_expression >> $temp_csv_file
number_lines=`expr $(wc -l < $temp_csv_file) - 1`
gnuplot_friendly $temp_csv_file
sed -i -e 's/expenses\://g' $temp_csv_file

(cat <<EOF) | gnuplot
  set terminal 'png'
  set output '$temp_graph_file'
  set style data histogram
  set style histogram rowstacked
  set style fill solid
  set key autotitle columnheader
  set key invert inside
  set boxwidth 0.75
  set xtics rotate by -45 scale 0
  plot for [i=3:$number_lines] "$temp_csv_file" using i:xtic(1) 
EOF

display_function $temp_graph_file

source ~/.financialscripts/visualizing/inc/footer.sh
