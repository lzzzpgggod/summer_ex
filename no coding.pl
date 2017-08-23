#!/usr/bin/perl
open (ZS,"zs97_isoseq_genelocus.txt") or die $!;
open (HOT,"hot_spot.sam") or die $!;
open (OUT,">no coding.psl") or die $!;
while (<ZS>) {
	chomp;
	@a = split(/\s+/,$_);
	@b=split(/,/,$a[20]);
	$name_cstart=$a[13]."\t".$b[0];
	push (@cstart,$name_cstart);
	push (@coding,$_);
}
while (<HOT>) {
	chomp;
	@a=split(/\s+/,$_);
	if ($a[0]>=1) {
		@b=split(/,/,$a[20]);
		#print "$b[0]\n";
		$name_start=$a[13]."\t".$b[0];
		push (@start,$name_start);
		push (@sum,$_);
		#print "$a[-1]";
	}
	

}
=pod
for ($s=1;$s<=10;$s++) {
	$nu=0;
	foreach $i (@cstart) {
		@a=split(/\t/,$i);
		foreach $j (@start) {
			@b=split(/\t/,$j);
			$dis=$a[1]-$b[1];
			$distance=$s*30;
			$distance_=-$distance;
			if ($a[0] eq $b[0] and $dis <$distance and $dis >$distance_) {
				$nu++;
			}
			else{
				#print OUT ""
			}
		}
	}
	print "$nu\n";

}
=cut

	$nu=0;
	$z=0;
foreach $i (@start) {
	@a=split(/\t/,$i);
	$n=1;
	foreach $j (@cstart) {
		if ($n==1) {
			@b=split(/\t/,$j);
			#print "$a[1]\t$b[1]\n";
			$dis=$a[1]-$b[1];
			$distance=380;
			$distance_=-$distance;
			if ($a[0] eq $b[0] and $dis <$distance and $dis >$distance_) {
				$nu++;
				$n=0;
			}
		}
	}
	if ($n==1) {
		print OUT "$sum[$z]\n";
	}
	$z++;
}
print "$nu\n";


=pod
foreach $i (@cname) {
	foreach $j (@name) {
		if ($i eq $j) {
			#$nu++;
		}
	}
}
=cut



close ZS;
close HOT;
close OUT;
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
		$distance=380;
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
