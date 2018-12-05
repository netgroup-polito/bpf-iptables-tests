BEGIN {
	total=0;
}
{
	total=total+$3;
}
END {
	total=total+$4;
	print total;
}
