BEGIN {
	total=0;
}
{
	j=0;
	for (i = 1; i <= NF; ++i) {
		if ($i == "packets") {
			j = i + 1;
			total = total + $j;
		}
    	}
}
END {
	print total;
}
