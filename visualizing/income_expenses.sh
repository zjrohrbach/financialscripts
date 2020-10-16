#!/bin/bash
source ~/.financialscripts/visualizing/inc/header.sh

#generate data from hledger
echo '"#"' > $temp_csv_file
hledger -f $HLEDGER_FILE bal --auto -M -O csv --depth=1 income expenses >> $temp_csv_file
gnuplot_friendly $temp_csv_file

(cat <<EOF) | gnuplot
  set terminal 'png'
  set output '$temp_graph_file'
  set style data histogram
  set style fill solid
  set xtics rotate by -45 scale 0
  set yrange [0:]
  red = "#FF0000"; green = "#00FF00";
  plot "$temp_csv_file" using 3:xtic(2) title "expenses" linecolor rgb red, \
              ''	using 4 title "income" linecolor rgb green 
EOF

display_function $temp_graph_file

source ~/.financialscripts/visualizing/inc/footer.sh
