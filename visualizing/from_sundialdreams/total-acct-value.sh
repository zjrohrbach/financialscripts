#from https://www.sundialdreams.com/report-scripts-for-ledger-cli-with-gnuplot/

LEDGER_TERM="qt size 1280,720 persist"


ledger -J reg "$@" -M --collapse --plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(quantity(scrub(display_total)))\n" > ledgeroutput1.tmp

(cat <<EOF) | gnuplot
	set terminal $LEDGER_TERM
	set style data linespoints
	set style histogram clustered gap 1
	set style fill transparent solid 0.4 noborder
	set xtics nomirror scale 0 center
	set ytics add ('' 0) scale 0
	set border 1
	set grid ytics
	set title "Monthly $@"
	set ylabel "Amount"
	plot "ledgeroutput1.tmp" using 2:xticlabels(strftime('%b', strptime('%Y-%m-%d', strcol(1)))) notitle linecolor rgb "turquoise", '' using 0:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle
EOF

rm ledgeroutput*.tmp
