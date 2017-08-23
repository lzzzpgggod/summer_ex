#!/usr/bin/perl
#!/usr/bin/perl
open (GFF,"ZS97.gff3") or die $!;
open (MH,"zs97_isoseq_result.sorted.psl") or die $!;
open (OUT,">zs97_isoseq_result_comp.txt") or die $!;
#open (GFF,"C:/Users/lenovo/Desktop/aa.txt") or die $!;
#open (MH,"C:/Users/lenovo/Desktop/b.txt") or die $!;
#open (OUT,">C:/Users/lenovo/Desktop/out.txt") or die $!;
$i=0;
while (<GFF>) {
	chomp;
	@a = split(/\s+/,$_);
	#$t = $a[6];
	#print "$t\n";
	if ($a[2] eq "mRNA") {
		$a[8]=~/ID=(.*);Name/;
		$ID = $1;
		$key = "$a[0] $a[6] $ID";
		#print "$key\n";
		$z=$a[3]."\t".$a[4];
		push (@rna,$z);
	}
	if ($a[8]=~/$ID/ && $a[2] eq "exon" && $key=~/ \+ /) {
		#print "1\n";
		push @{$h{$key}},($a[3],$a[4]);
	}
	if ($a[8]=~/$ID/ && $a[2] eq "exon" && $key=~/ - /) {
		push @{$h{$key}},($a[4],$a[3]);
	}
}
for $k (keys %h) {
	#print "$k\n";
	@aa = split(/ /,$k);
	pop @{$h{$k}};
	shift @{$h{$k}};
	if ($k=~/ - /) {
		#print "1\n";
		@{$h{$k}}=reverse(@{$h{$k}});
	}
	#unshift(@{$h{$k}},$t);
	unshift(@{$h{$k}},$aa[0]);
	for ($i=0;$i<6;$i++) {
		$value_1 = undef;
		$j=2;
		for (@{$h{$k}}) {
			#print "$_\n";
			$a=$_;
			if ($_=~ /^\d+$/ and $j%2 eq 0) {
				$a=$_-$i;
				$j++;
			}
			if ($_=~ /^\d+$/ and $j%2 ne 0) {
				$a=$_+$i;
				$j++;
			}
			$value_1 = $value_1.$a;
			#print "$value_1\n";

		}
		$hash{$value_1} = $k;
	}	
}
=pod
for (keys %hash) {
	print OUT "$_\n$hash{$_}\n";
}
=cut
$num=0;
while (<MH>) {
	chomp;
	@a = split(/\s+/,$_);
	if ($a[17] != 1) {
		@b = split(/,/,$a[18]);
		@c = split(/,/,$a[20]);
		#print "@c\n";
		$size = @b;
		$size_1 = $size-1;
		@l = ();
		for ($i=0;$i<$size_1 ;$i++) {
			$im_1 = $b[$i]+$c[$i];
			#print "$im_1\n";
			push @l,$im_1;
		}
		#print "@l\n";
		shift @c;
		$ll = @c;
		#print "@c\n";
		for ($i=0;$i<$ll ;$i++) {
			$c[$i] = $c[$i]+1;
		}
		$v = undef;
		for ($i=0;$i<$size_1;$i++) {
			#print "1\n";
			$v = $v.$l[$i].$c[$i];
		}
		$v = $a[13].$v;
		$s{$v} = $_;
	}
	else{
		#
		@b = split(/,/,$a[18]);
		@c = split(/,/,$a[20]);
		$size=$b[0];
		$start=$c[0]+1;
		$end=$size+$start;
		$one=$size."\t".$start."\t".$end;
		$one{$one}=$_;
		$num++;
	}

}
=pod
for (keys %s) {
	print OUT "$_\n$s{$_}\n";
}
=cut
print "$num\n";
foreach $k (keys %s) {
	if (exists $hash{$k}) {
		#print "1\n";
		print OUT "$s{$k}\n";
		#print "$s{$k}\n";
	}
}
foreach  $keys(keys %one) {
	@sse=split (/\t/,$keys);
	$s=0;
	if ($sse[0] >50) {
		foreach $mrna (@rna) {
			if ($s==0) {
				@mrna=split(/\t/,$mrna);
				if ($mrna[0]<=$sse[1] and $mrna[1]>=$sse[2]) {
					print OUT "$one{$keys}\n";
					$s=1;
				}
			}
		}
	}
}
close GFF;
close MH;
close OUT;
