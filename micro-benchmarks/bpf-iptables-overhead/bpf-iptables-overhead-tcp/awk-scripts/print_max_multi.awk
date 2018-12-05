BEGIN {
	total=0;
}
{
	if(NR==9 || NR==17 || NR==25 || NR==33 || NR==41) {
		if ($2>max+0.0)
			max = $2;
	}
}
END {
	printf("%.f\n", max);
}
