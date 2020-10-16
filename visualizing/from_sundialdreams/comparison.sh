#from https://www.sundialdreams.com/report-scripts-for-ledger-cli-with-gnuplot/

LEDGER_TERM="qt size 1280,720 persist"
first_acct="$1"
second_acct="$2"

ledger -j reg "$first_acct" -M --collapse > ledgeroutput1.tmp
ledger -j reg "$second_acct" -M --collapse > ledgeroutput2.tmp

(cat <<EOF) | gnuplot
  set terminal $LEDGER_TERM
  set style data histogram
  set style histogram clustered gap 1
  set style fill transparent solid 0.4 noborder
  set xtics nomirror scale 0 center
  set ytics add ('' 0) scale 0
  set border 1
  set grid ytics
  set title "Comparing $first_acct to $second_acct"
  set ylabel "Amount"
  plot "ledgeroutput1.tmp" using 2:xticlabels(strftime('%b', strptime('%Y-%m-%d', strcol(1)))) title "$first_acct" linecolor rgb "blue", '' using 0:2:2 with labels left font "Courier,8" rotate by 15 offset -4,0.5 textcolor linestyle 0 notitle, "ledgeroutput2.tmp" using 2 title "$second_acct" linecolor rgb "orange", '' using 0:2:2 with labels left font "Courier,8" rotate by 15 offset 0,0.5 textcolor linestyle 0 notitle
EOF

rm ledgeroutput*.tmp
