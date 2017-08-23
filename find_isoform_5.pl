#! /usr/bin/perl
#统计归类isoform，并找到isoform的热点区域
sub seq_handle{
#
	($file)=@_;
	#%name_pos=();
	%name_seq=();@name=();
	@name_pos=();
	print "$file\n";
	open (IN,"$file")or die $!;
	while(<IN>){
		my @line,@head;
		@line=split (/\t/,$_);
		#@head=split (//,$line[0]);
		#print "@head\n";
		@s=split(/,/,$line[20]);
		push(@name,$line[13]);
		push(@name_pos,$s[0]);
		#$name_pos{$line[0]}=$line[3];
		#print "$name_pos{$line[0]}";	
		#$name_seq{$line[0]}=$line[9];
		#print "$name_seq{$line[0]}";
		push(@iso,$_);
			
	}
	close(IN);
	return (\@name_pos,\@name,\@iso);
	
}

sub pos_dis{
	#
	$pos_num=0;
	my ($name,$name_pos,$distance,$iso)=@_;
	my (@name)=(@$name);
	@name_pos=@$name_pos;
	@iso=@$iso;
	@iso_dis;
	my $nu=0;
	$pos=$name_pos[$nu];
	
	#print "$pos\n";
	$mu_name;
	foreach $name (@name) {
		#print $name;
		my $dis=$name_pos[$nu]-$pos;
		#print "$dis\n";
		#print "$dis\t";
		$pos=$name_pos[$nu];
		if ($dis<$distance) {
			if (defined $mu_name) {
				
				$mu_name=$mu_name."\t".$name;
				#print "$mu_name\n";
			}
			else{
				$mu_name=$name;
				#print "$mu_name\n";
			}
			#print "$mu_name\n";
		}
		else {
			$nu_names{$pos_num}=$mu_name;
			$pos_num++;
			#print "$mu_name\n";
			$mu_name=$name;
			$iso_dis{$pos_num}=$iso[$nu];
		}
		$nu++;
	}
	#print $nu_names{1};
	#print "$pos_num";
	return ($pos_num,\@nu_names,\@iso_dis);  
	
}
sub hotspot{
	my ($nu_names,$iso_dis)=@_;
	@nu_names=@$nu_names;
	@iso_dis=@$iso_dis;
	$hot_spot=0;
	@output;
	foreach $key (keys %nu_names) {
		my @names=split (/\t/,$nu_names{$key});
		$long=scalar @names;
		$sum=0;
		if ($long>=5) {
			$hot_spot++;
			@number=sort @names;
			push(@output,$iso_dis{$key});
		}
	}
	#print "$hot_spot\n";
	return ($hot_spot,\@average,\@output);
}
sub similar_hotspot{
	my ($nu_names,$name_seq)=@_;
	my (@nu_names,@name_seq)=(@$nu_names,@$name_seq);
	my $num_isoform=1; 
	$a=1;
	$hot_spot=0;
	$dis_hotspot=0;
	$hot_spot_num=0;
	foreach $nu (keys %nu_names) {
		my @names=split (/\t/,$nu_names{$nu});
		#print "@names\n";
		$long=scalar @names;
		if ($long>=5) {
			$dis_hotspot++;
		}
		$no1=shift @names;
		while (@names) {
			$no2= shift @names;
			$break=1;
			$a++;
			#print "$no1\n1\n";
			$seq1=$name_seq{$no1};
			#print "$no2\n";
			$seq2=$name_seq{$no2};
			#print "$seq1\n";print "$seq2\n\n";
			@seq1=split (//,$seq1);
			@seq2=split (//,$seq2);
			#print "@seq1\n";
			@_100_seq1=@seq1[0..199];
			@_100_seq2=@seq2[0..199];
			@seq1_100=@seq1[-200,-1];
			@seq2_100=@seq2[-200,-1];
			for ($j=0;$j<100;$j++) {
				if ($break==1) {
					$max=199-$j;
					@head_seq1=@_100_seq1[$j..198];
					@head_seq2=@_100_seq2[-199..-1+$j];
					@tail_seq1=@seq1_100[-199..-1+$j];
					@tail_seq2=@seq2_100[$j..198];
					if (scalar @head_seq1!= 0 and scalar @head_seq2!= 0 and scalar @tail_seq1!= 0 and scalar @tail_seq2!= 0) {
						$l=scalar @head_seq1;
						#print "$l\n";
						$defen_head=0;
						$defen_tail=0;
						#print "@head_seq1\n";
						#print "@head_seq2\n\n";
						
						for ($i=0;$i<$max;$i++) {
							if (@head_seq1[$i] eq @head_seq2[$i]) {
								$defen_head++;
							}
							if (@tail_seq2[$i] eq @tail_seq2[$i]) {
								$defen_tail++;
							}
						}
						$cc_1=$defen_head/$max;
						#print "$cc_1\n";
						$cc_2=$defen_tail/$max;
						if ($cc_1>=0.85 and $cc_2>=0.85) {
							$hot_spot_num++;
							#print "$num_isoform\n";
							$break=0;
						}
					}
				}
					
			}
			if ($break==1) {
				$num_isoform++;
			}
			$no1=$no2;
		}
		if ($hot_spot_num>=5) {
			$hot_spot++;
		}
		$hot_spot_num=0;
	}
	#print "$a\n\n";
	return ($dis_hotspot,$hot_spot,$num_isoform);
}

sub locus{
	my ($input_file_2,$average)=@_;
	my @average=@$average;
	my $i=0;
	my $j=0;
	open (IN,"$file")or die $!;
	@gene_pos=();
	while (<IN>) {
		@line=split (/\t/,$_);
		if ($line[2] eq 'gene') {
			#print "@line\n";
			$pos_pos=$line[3]."\t".$line[4];
			push (@gene_pos,$pos_pos);
		}
	}
	close(IN);
	foreach $key (keys %average) {
		$i++;
		foreach  (@gene_pos) {
			@pos=split(/\t/,$_);
			if ($average{$key}>$line[0] and $average{$key}<$line[1]) {
				$j++;
			}
		}

	}
	$value=$j/$i;
	return ($value);
}

sub out_put{
	my ($output_file,$output)=@_;
	@output=@$output;
	open (OUT,">$output_file")or die $!;
	foreach  (@output) {
		print OUT "$_\n";
	}
	close OUT;

}

sub main{
	($output_file,$input_file_1,$dis,$input_file_2)=@_;
	#$output_file='find_isoform_result';
	#$input_file=('test_sam.txt');
	my ($name_pos,$name,$iso)=&seq_handle($input_file_1);
	my (@name,@name_seq)=(@$name,@$name_seq);
	@name_pos=@$name_pos;
	@iso=@$iso;
	my ($pos_num,$nu_names,$iso_dis)=&pos_dis($name,$name_pos,$dis,$iso);
	print "$pos_num\n";
	my (@nu_names)=(@$nu_names);
	my ($hot_spot,$average,$output)=&hotspot($nu_names,$iso_dis);
	print "$hot_spot\n";
	my @average=@$average;
	#my $value=&locus($input_file_2,$average);
	#print "$value\n";
	#my ($dis_hotspot,$hot_spot,$num_isoform)=&similar_hotspot($nu_names,$name_seq);
	#print "$num_isoform\n$hot_spot\n$dis_hotspot\n$pos_num";
	&out_put($output_file,$output);
	#foreach $key (keys %name_pos) {
	#	$lzp++;
	#}
	
}
$input_file_1="zs97_isoseq_result.sorted.psl";
$input_file_2='ZS97.gff3';
#$input_file_2='ZS_forward_mapped_reads.sam';
$output_file='hot_spot.sam';
#for ($i=1;$i<2000;$i=$i+10) {
#	push(@dis,$i);
#}
#取dis为380；
@dis=(380);
foreach $dis (@dis) {
		&main($output_file,$input_file_1,$dis,$input_file_2);
}
	
