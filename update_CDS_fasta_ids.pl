#!/usr/bin/env perl 
use strict;
use warnings;
use Getopt::Long;

my $usage = qq{
$0  -  process a CDS fasta file and update the ids from -RA style to -RA-CDS style IDs
USAGE:
perl $0 -i <input_fasta_file.fa> -o <output_file.fa>
};

my $in;
my $out;
my $help;
GetOptions ("in=s" => \$in,     # string
	    "out=s" => \$out,     # string
             "help+" =>\$help)
    or die("Error in command line arguments\n$usage\n");
if ($help){
    die $usage;
}
if ($in eq $out){
    die "\nError running $0\n\tThe input file $in cannot be the same as the output file $out\n";
}

open (my $IN, $in)||die "Could not open $in for reading \n$!\n";
my $output;
$output = $out;

open (my $OUTPUT, ">$output") || die "Could not open $output for reading\n$!\n";
while (<$IN>){
    if ($_ =~ m/^(>.*)$/){
	chomp $_;
	print $OUTPUT "$1-CDS\n";
    }
    else {
	print $OUTPUT $_;
    }
}
close ($IN);
close ($OUTPUT);
