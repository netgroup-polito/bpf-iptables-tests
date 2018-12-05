BEGIN {
	total=0;
}
{
	if(NR==9 || NR==17 || NR==25 || NR==33 || NR==41)
		total = total + $2;
}
END {
	avg = total/5;
	printf("%.f\n", avg);
}
