#!/usr/bin/perl
use strict;
use warnings;

use Cwd;

my $proportion = $ARGV[0];
my $workingdirectory = $ARGV[1];

print "This perl script was written by Catherine Attard\nPlease cite Attard et al. (in review) \"Genomic interrogation to manage mistakes in fisheries stocking of threatened species\" when using this script\nCatherine makes no guarantee that this script is bug-free; use at your own risk and please report bugs to catherine.r.attard\@gmail.com\n";
print "\nThe script is designed for introducing missing data to genotype data simulated with no missing data\n";

if (not defined ($proportion)) {
	print "\nYou have not defined the missing data rate. The correct command useage for this perl script is:\nperl SimulatingMissingData.pl missing_data_rate working_directory_(optional)\n";
	exit;
	}

if (defined ($workingdirectory)){
	print "\nI will use $workingdirectory as my working directory\n"
	}
	
if (not defined ($workingdirectory)){
	$workingdirectory = getcwd();
	print "\nAs you have not defined a working directory, I will use the current directory of this perl script as the working directory. This is $workingdirectory\n"
	}

open (IN, "<${workingdirectory}/GenotypeData.txt") or die "\nCan not open input file: $!. Check that it is in the working directory and called GenotypeData.txt\n";
my @line = <IN>;
close IN;

rename("${workingdirectory}/GenotypeData.txt", "${workingdirectory}/GenotypeDataOriginal.txt") or die "\nRename of your input file, GenotypeData.txt, to GenotypeDataOriginal.txt was unsuccessful: $!.\n";

open (OUT, ">>${workingdirectory}/GenotypeData.txt") or die "\nCan not create output file: $!\n";

print "\nI have successfully renamed your original GenotypeData.txt file to GenotypeDataOriginal.txt (just in case you want a copy!)\n\nI am now introducing $proportion missing data to this data and outputting it into a file called GenotypeData.txt\n";

print OUT $line[0]; #HASH OUT this line if no top row of locus names
for (my $count=1;$count<scalar(@line);$count = $count+2) { #CHANGE $count=1 to $count=0 if no top row of locus names.
	chomp $line[$count];
	chomp $line[$count+1];
	my @allele1line = split (/\s/, $line[$count]);
	my @allele2line = split (/\s/, $line[$count+1]);
	for (my $count2=2; $count2<scalar(@allele1line);$count2++) { #CHANGE $count2=2 to $count2=1 if no population column
		my $randomnumber = rand();
		if ($randomnumber <= $proportion) {
			$allele1line[$count2] = $allele2line[$count2] = -9;
		}
	}
	print OUT $allele1line[0]; #Prints out individual ID
	print OUT "\t".$allele1line[1]; #Prints out population label, HASH OUT this line if no population column
	for (my $count2=2; $count2<scalar(@allele1line);$count2++) { #CHANGE $count2=2 TO $count2=1 if no population column
		print OUT " ".$allele1line[$count2];
		}
	print OUT "\n";
	print OUT $allele2line[0]; #Prints out individual ID
	print OUT "\t".$allele2line[1]; #Prints out population label, HASH OUT this line if no population column
	for (my $count2=2; $count2<scalar(@allele2line);$count2++) { #CHANGE $count2=2 to $count2=1 if no population column
		print OUT " ".$allele2line[$count2];
		}
	print OUT "\n";
}
close OUT;
print "\nI have finished! Do not accidentally repeat this script as you'll be introducing more missing data to your missing data dataset!\n";
