#!/usr/bin/perl

# from simpleLM
    open OUTPUT,'>',$ARGV[0] . ".dic";
    open NOTFOUND,'>',$ARGV[0] . ".notfound";

for ($dicNum = 1; $dicNum < $#ARGV+1; $dicNum++) {
    print STDERR $ARGV[$dicNum];
    # Slurp the whole thing, makes life easier...unless you are without enough swap
    open DICT, $ARGV[$dicNum] || die "Can not open cmu_dict ($CMU_DICT)\n";
    @dict = <DICT>;
    close DICT;

    for (@dict) {		# Create a hash of the dict entries
	/(\S+)\s+(.*)$/;
	$word = lc($1); $pron = $2;

#	print "$1 $2\n";

# strip numbers from phones
	$pron =~ s/[0-9]//g;


	$d{lc($word)} = $pron;
    }
}


print STDERR $ARGV[0]. ".vocab\n";
    open VOCAB, $ARGV[0]. ".vocab";
    while (<VOCAB>) {
	chomp;
	if (/^#/ || /^\s*$/)
	{next}

	$_ = lc($_);
#	print STDERR "$_\n";
#	print 
	if ($d{$_}) {
#	print STDERR $_;

	    printf OUTPUT "%-30s$d{$_}\n",$_;
	    
	    # Dictionary might contain multiple pronunciations of the same
	    # word. Each version has a (counter) appended to the word e.g. 
	    # WITH                     	W IH DH
	    # WITH(2)                  	W IH TH
	    # WITH(3)                  	W IX DH
	    # WITH(4)                  	W IX TH
	    $i=2;			
	    while ($dup = $d{"$_($i)"}) {
		printf OUTPUT "%-30s$dup\n","$_($i)";
		$i++;
	    }
	}
	else {
	    print STDERR "Can't find $_\n";
	    print NOTFOUND "$_\n";
	}
    }
    close VOCAB;
    close OUTPUT;

