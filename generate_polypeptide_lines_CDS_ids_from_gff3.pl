#!/usr/bin/env perl 
use strict;
use warnings;
use Getopt::Long;

my $usage = qq{
$0  -  process a gff3 file and add polypeptide lines based on the CDS span. This program also generates distinct IDs for CDS features so they do not collide with the cDNA IDs
USAGE:
perl $0 -g <Input_gff3_file.gff3> -o <output_file.gff3>
};

my %fmin;
my %fmax;
my %parent;
my %source;
my %scaffold;
my %strand;
my $gff;
my $out;
my $help = ''; # Default to false

GetOptions ("gff=s" => \$gff,     # string
	    "out=s" => \$out,     # string
             "help+" =>\$help)
    or die("Error in command line arguments\n$usage\n");
if ($help){
    die $usage;
}
if ($gff eq $out){
    die "\nError running $0\n\tThe input file $gff cannot be the same as the output file $out\n";
}
# Scaffold2747	I5K	CDS	17520	17543	.	+	0	Parent=test-OFAS017942-RA
# Scaffold2747	I5K	CDS	20118	20133	.	+	0	Parent=test-OFAS017942-RA
# Scaffold2747	I5K	CDS	20238	20542	.	+	2	Parent=test-OFAS017942-RA
open (my $GFF, $gff)||die "Could not open $gff for reading \n$!\n";


while (<$GFF>){
    chomp $_;
    my @line = split /\t/, $_;
    if (scalar (@line) == 9 && $line[2] eq 'CDS'){
#	print "$_\n";
	$line[8] =~ m/Parent=([^;]+)/;
	my $parent = $1;
	my $id = $parent;
	$id =~ s/-R(.)$/-P$1/;
#	print "$id\t$parent\n";
	if (!defined($parent{$id})){
	    $parent{$id} = $parent;
	    $source{$id} = $line[1];
	    $scaffold{$id} = $line[0];
	    $fmin{$id} = $line[3];
	    $fmax{$id} = $line[4];
	    $strand{$id} = $line[6];
	}elsif(defined($parent{$id}) && ($fmin{$id} > $line[3])){
	    $fmin{$id} = $line[3];
	}elsif(defined($parent{$id}) && ($fmax{$id} < $line[4])){
	    $fmax{$id} = $line[4];
	}
    }
}
close ($GFF);

open (my $GFF2, $gff)||die "Could not open $gff for reading \n$!\n";
my $output;
#if ($out eq ''){
#    $output = $gff;
#    $output =~s/(.gff*)$/_NAL_pep_$1/;
#}else{
    $output = $out;
#}
#die "$gff\t$output\n\n";
open (my $OUTPUT, ">$output") || die "Could not open $output for reading\n$!\n";
my %print_pep;
while (<$GFF2>){
    chomp $_;
    my @line = split /\t/, $_;
    if (scalar (@line) == 9 && $line[2] eq 'CDS'){
	$line[8] =~ m/Parent=([^;]+)/;
        my $parent = $1;
	if (!defined ($print_pep{$parent})){
	    $print_pep{$parent}++;
	    my $id = $parent;
	    $id =~ s/-R(.)$/-P$1/;
	    my $parent = $parent{$id};
	    my $start = $fmin{$id};
	    my $end = $fmax{$id};
	    my $source = $source{$id};
	    my $strand = $strand{$id};
	    my $scaffold = $scaffold{$id};
#	    print $OUTPUT "$scaffold\t$source\tCDS\t$start\t$end\t.\t$strand\t.\tID=$parent"."-CDS;Parent=$parent\n";
	    print $OUTPUT "$scaffold\t$source\tpolypeptide\t$start\t$end\t.\t$strand\t.\tID=$id;Parent=$parent\n";
	}
	$line[8] = "ID=$parent"."-CDS;Parent=$parent";
	$_ = join ("\t", @line);
    }
    print $OUTPUT $_ . "\n";    
}
close ($GFF2);
close ($OUTPUT);
