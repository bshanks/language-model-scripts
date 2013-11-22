#!/usr/bin/perl


sub separate_by_spaces {
  $_ = shift;
#  print STDERR "*******\n";
#  print STDERR "$_\n";
  s/(.)/$1 /g;
#  print STDERR "$_\n";
#  print STDERR "*******\n";
  return $_;
}


open(WORDS, $ARGV[0]);
#open(WORDS_OMIT, $ARGV[1]);
#open(TARGET, $ARGV[2]);
open(TARGET, $ARGV[1]);

while (<WORDS>) {
    chomp; 
    $_=lc($_);
    $wc{$_} = 1;
} 

#while (<WORDS_OMIT>) {
#    chomp;
#    $words_to_omit{lc($_)} = 1;
#} 


undef $/;

$_ = <TARGET>;

# clean out weird characters
s/(?!\n)[[:^ascii:][:cntrl:]]//g;

$_ = lc($_);

for $key (keys %wc) {
    #print "     $wc{$key} $key"
#    if (! $words_to_omit{$key}) {
#	print STDERR "Finding $key\n";
	$ucKey = uc($key);
	$key = quotemeta($key);
	$ucKey = quotemeta($ucKey);
#	print STDERR "Before:\n$_";
	s/(^|(?<=[^a-zA-Z0-9_\-]))$key($|(?=[^a-zA-Z0-9_\-]))/ $ucKey /g;
#	print STDERR "After:\n$_";
#    }
}

#print STDERR $_;

for $key (keys %wc) {
#    if (! $words_to_omit{$key}) {
	$ucKey = uc($key);

	$key = quotemeta($key);
	$ucKey = quotemeta($ucKey);
	s/(^|(?<=[^a-zA-Z_\-]))$key($|(?=[^a-zA-Z_\-]))/ $ucKey /g;
#    }
}

for $key (keys %wc) {
#    if (! $words_to_omit{$key}) {
	$ucKey = uc($key);

	$key = quotemeta($key);
	$ucKey = quotemeta($ucKey);
	s/(^|(?<=[^a-zA-Z_]))$key($|(?=[^a-zA-Z_]))/ $ucKey /g;
#    }
}


for $key (keys %wc) {
#    if (! $words_to_omit{$key}) {
	$ucKey = uc($key);

	$key = quotemeta($key);
	$ucKey = quotemeta($ucKey);
	s/(^|(?<=[^a-zA-Z]))$key($|(?=[^a-zA-Z]))/ $ucKey /g;
#    }
}




##s/([^ A-Z0-9_\-])\b([A-Z0-9_\-])/$1 $2/g;
##s/([A-Z0-9_\-])\b([^ A-Z0-9_\-])/$1 $2/g;

#s/(?<![ A-Z0-9_\-])(?=[A-Z0-9_\-])/ /g;
#s/(?<=[A-Z0-9_\-])(?![ A-Z0-9_\-])/ /g;




s/(^|(?<=[^A-Z0-9_\-]{2})) ($|(?=[^A-Z0-9_\-]))/ BRAY /g;  # bug: doesn't catch the space in "_ -"


s/(^|(?<=[^A-Z0-9_\-]))([0-9_\-]{2,})($|(?=[^A-Z0-9_\-]))/separate_by_spaces($2)/eg;
#print STDERR $_;

s/(^|(?<=[^A-Z0-9_\-]))8($|(?=[^A-Z0-9_\-]))/ EIGHT /g;
s/(^|(?<=[^A-Z0-9_\-]))5($|(?=[^A-Z0-9_\-]))/ FIVE /g;
s/(^|(?<=[^A-Z0-9_\-]))4($|(?=[^A-Z0-9_\-]))/ FOUR /g;
s/(^|(?<=[^A-Z0-9_\-]))9($|(?=[^A-Z0-9_\-]))/ NINE /g;
s/(^|(?<=[^A-Z0-9_\-]))1($|(?=[^A-Z0-9_\-]))/ ONE /g;
s/(^|(?<=[^A-Z0-9_\-]))7($|(?=[^A-Z0-9_\-]))/ SEVEN /g;
s/(^|(?<=[^A-Z0-9_\-]))6($|(?=[^A-Z0-9_\-]))/ SIX /g;
s/(^|(?<=[^A-Z0-9_\-]))3($|(?=[^A-Z0-9_\-]))/ THREE /g;
s/(^|(?<=[^A-Z0-9_\-]))2($|(?=[^A-Z0-9_\-]))/ TWO /g;
s/(^|(?<=[^A-Z0-9_\-]))0($|(?=[^A-Z0-9_\-]))/ ZERO /g;

s/(^|(?<=[^A-Z0-9_\-]))-($|(?=[^A-Z0-9_\-]))/ DASH /g;



s/(^|(?<=[^A-Z0-9_\-]))_($|(?=[^A-Z0-9_\-]))/ UNDERSCORE /g;

s/(^|(?<=[^A-Z0-9_\-]))'($|(?=[^A-Z0-9_\-]))/} APOSTROPHE /g;


 s/>/ GREATER_THAN_SIGN /g;
 s/</ LESS_THAN_SIGN /g;


#print STDERR $_;

s/a/ ALFA /g;
#s/a/ A /g;
s/b/ BRAVO /g;
s/c/ CHARLIE /g;
s/d/ DELTA /g;
s/e/ ECHO /g;
s/f/ FOXTROT /g;
s/g/ GINGER /g;
s/h/ HENRY /g;
s/i/ INDIA /g;
#s/i/ I /g;
s/j/ JULIET /g;
s/k/ KILO /g;
s/l/ LIMA /g;
s/m/ MICHAEL /g;
s/n/ NOVEMBER /g;
s/o/ OSCAR /g;
s/p/ PETER /g;
s/q/ QUEBEC /g;
s/r/ ROBBIE /g;
s/s/ SIERRA /g;
s/t/ TANGO /g;
s/u/ UNIFORM /g;
s/v/ VICTOR /g;
s/w/ WHISKEY /g;
s/x/ X-RAY /g;
s/y/ YANKEE /g;
s/z/ ZULU /g;
s/`/ BACKTICK /g;
s/"/ QUOTATION /g;
s/\// SLASH /g;
s/,/ COMMA /g;
s/:/ COLON /g;
s/;/ SEMICOLON /g;
s/#/ NUMBER_SIGN /g;
s/\./ PERIOD /g;
s/\\/ BACKSLASH /g;
s/@/ AT_SIGN /g;
s/\*/ STAR /g;
s/\(/ LEFT_PARENS /g;
s/\)/ RIGHT_PARENS /g;
s/{/ LEFT_BRACE /g;
s/}/ RIGHT_BRACE /g;
s/=/ EQUALS /g;
s/\+/ PLUS /g;
s/&/ AMPERSAND /g;
s/\^/ CIRCUMFLEX /g;
s/\$/ DOLLAR_SIGN /g;
s/%/ PERCENT /g;
s/!/ EXCLAMATION /g;
s/\?/ QUESTION_MARK /g;
s/~/ TWIDDLE /g;
s/\|/ VERTICAL_BAR /g;
s/\[/ LEFT_BRACKET /g;
s/\]/ RIGHT_BRACKET /g;
s/\t/ TABULAR /g;

#s/\n/NEWLINE_PLACEHOLDER/g;
#s/NEWLINE_PLACEHOLDER/ENTER_KEY\n/g;
s/\n/ ENTER_KEY\n/g;


# clean out weird characters
#s/[^ A-Z_-1-9\n\t]//g;


open(OUTPUT, '>', $ARGV[2]);

print OUTPUT;
