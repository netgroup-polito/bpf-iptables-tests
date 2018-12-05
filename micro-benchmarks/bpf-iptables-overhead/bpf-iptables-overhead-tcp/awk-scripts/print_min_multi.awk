BEGIN {
	min=10000000.0;
}
{
	if(NR==9 || NR==17 || NR==25 || NR==33 || NR==41) {
		if ($2 < min+0.0)
			min = $2;
	}
}
END {
	printf("%.f\n", min);
}
