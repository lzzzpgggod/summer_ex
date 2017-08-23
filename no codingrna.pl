open (NC,"no coding.psl") or die $!;
while (<NC>) {
	chomp;
	@a = split(/\s+/,$_);
	@b=split(/,/,$a[20]);
	$name_cstart=$a[13]."\t".$b[0];
	push (@nostart,$name_cstart);
	push (@nocoding,$_)

}
open (IN,"zs97_isoseq_result.sorted.psl")or die $!;
while(<IN>){
	chomp;
	@a = split(/\s+/,$_);
	@b=split(/,/,$a[20]);
	$name_cstart=$a[13]."\t".$b[0];
	push (@zs,$name_cstart);
	push (@zs_s,$_)
			
}
$num=0;
foreach $i (@zs) {
	@a=split(/\t/,$i);
	$n=1;
	foreach $j (@nostart) {
		@b=split(/\t/,$j);
		$dis=$a[1]-$b[1];
		$distance=38;
		$distance_=-$distance;
		if ($a[0] eq $b[0] and $dis <$distance and $dis >$distance_) {
			$n=0;
		}
	}
	if ($n==0) {
		#print "";
		$num++;
	}
}
print "$num\n";
close NC;
close IN;