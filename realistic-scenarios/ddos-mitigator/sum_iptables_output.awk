BEGIN {
	total=0;
}
{
	if (NR == 1) {
		total=total+$5;
	} else if (NR != 2) {
		total=total+$1;
	}
}
END {
	print total;
}
