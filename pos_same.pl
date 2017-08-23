#!/usr/bin/perl
#open (MH,"C:/Users/lenovo/Desktop/b.txt") or die $!;
#open (MH,"F:/Book/mh63_isoseq_result_comp.txt") or die $!;
#open (MH,"F:/Book/zs97_isoseq_result_comp.txt") or die $!;
open (ZS,"zs97_isoseq_result_comp.txt") or die $!;
open (OUT,">zs97_isoseq_genelocus.txt") or die $!;
@a = <ZS>;
$l = @a;
$c = 1;
for ($i=0;$i<$l ;$i++) {
	chomp $a[$i];
	@b = split(/\s+/,$a[$i]);
	#print "$b[15]\t$b[16]\n";
	for ($q = $i+1;$q<$l ;$q++) {
		@c = split(/\s+/,$a[$q]);
		$t = ($b[15]-$c[15])*($b[16]-$c[15])*($b[15]-$c[16])*($b[16]-$c[16]);
		if ($b[8] eq $c[8] && $t<0 && $b[13] == $c[13]) {
			if (exists $hash{$a[$i]}) {
				$hash{$a[$q]} = $hash{$a[$i]};
			}
			if (!exists $hash{$a[$i]}) {
				$hash{$a[$i]} = $c;
				$hash{$a[$q]} = $hash{$a[$i]};
				$c++;
				print OUT "$a[$i]\n";
			}
		}
	}
}
#print "$c";
close MH;
=pod
MH:2342
ZS:1995
=cut