#!/usr/bin/perl -p

#to do :update vocabulary  
sub dashes2underscores {
  $_ = shift;
  s/-/_/g;
return $_;}



s/^(?:[^|]+\|){3}[^|]+\|\|[^|]+\|//;


s/\[KeyName:\[[^\]]*\]\]/ /g;



#s/([^\]])\?/$1\//g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\~/${1}`/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\!/${1}1/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\@/${1}2/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\#/${1}3/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\$/${1}4/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\%/${1}5/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\^/${1}6/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\&/${1}7/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\*/${1}8/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\(/${1}9/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\)/${1}0/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])_/${1}\-/g;
s/(\[KeyName:[^\]]+\])/dashes2underscores($1)/ge;
#print STDERR $_;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\+/${1}=/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\{/$1\[/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\}/$1\]/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\[KeyName:bar\]/$1\\/g; #bug
s/(\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]e])\:/${1};/g; #bug
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\"/${1}'/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\</${1},/g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\>/$1\./g;
s/(^|\[KeyName:(?!Shift_[LR]\])[^\]]+\]|[^\]])\?/$1\//g;

 #bug: [KeyName:Shift_R]~1234567890_=
#bug: ]1

$_ = lc($_);
s/ /BRAY /g;
s/\[keyname:control_.\]/CONTROL /g;
s/\[keyname:alt_.\]/ALTERNATE /g;
s/\[keyname:super_.\]/SUPER /g;
s/\[keyname:_.\]/ /g;
s/\[keyname:_.\]/ /g;
s/\[keyname:_.\]/ /g;
s/\[keyname:_.\]/ /g;
s/\[keyname:_.\]/ /g;
s/\[keyname:return\]/ENTER_KEY\n /g;
s/\[keyname:next\]/PAGE_DOWN /g;
s/\[keyname:page_up\]/PAGE_UP /g;
s/\[keyname:backspace\]/ERASE /g;
s/\[keyname:up\]/UP_ARROW /g;
s/\[keyname:down\]/DOWN_ARROW /g;
s/\[keyname:left\]/LEFT_ARROW /g;
s/\[keyname:right\]/RIGHT_ARROW /g;
s/\[keyname:tab\]/TABULAR /g;
s/\[keyname:delete\]/DELETE /g;
s/\[keyname:home\]/HOME_KEY /g;
s/\[keyname:end\]/END_KEY /g;
s/\[keyname:shift_.\]\[keyname:bar\]/VERTICAL_BAR /g;
s/\[keyname:find\]/FIND_COMMAND /g;
s/\[keyname:f(\d+)\]/FUNCTION_KEY_$1 /g;
s/\[keyname:insert\]/INSERT /g;
s/\[keyname:caps_lock\]/CAPS_LOCK /g;
s/\[keyname:\]/ /g;
s/\[keyname:\]/ /g;
#s/(\[keyname:shift_.\])?/ /g;

s/(\[keyname:shift_.\])?"/QUOTATION /g;
 s/(\[keyname:shift_.\])?#/NUMBER_SIGN /g;
 s/(\[keyname:shift_.\])?@/AT_SIGN /g;
 s/(\[keyname:shift_.\])?\*/STAR /g;
 s/(\[keyname:shift_.\])?\(/LEFT_PARENS /g;
 s/(\[keyname:shift_.\])?\)/RIGHT_PARENS /g;
 s/(\[keyname:shift_.\])?\+/PLUS /g;
 s/(\[keyname:shift_.\])?&/AMPERSAND /g;
 s/(\[keyname:shift_.\])?\^/CIRCUMFLEX /g;
 s/(\[keyname:shift_.\])?\$/DOLLAR_SIGN /g;
 s/(\[keyname:shift_.\])?%/PERCENT /g;
 s/(\[keyname:shift_.\])?!/EXCLAMATION /g;
 s/(\[keyname:shift_.\])?\?/QUESTION /g;
 s/(\[keyname:shift_.\])?~/TWIDDLE /g;
 s/(\[keyname:shift_.\])_/UNDERSCORE /g;
 s/(\[keyname:shift_.\])?>/GREATER_THAN_SIGN /g;
 s/(\[keyname:shift_.\])?</LESS_THAN_SIGN /g;
 s/(\[keyname:shift_.\])?\{/LEFT_BRACE /g;
 s/(\[keyname:shift_.\])?\}/RIGHT_BRACE /g;

s/\[keyname:shift_.\]/SHIFT /g;


#print STDERR $_;
s/\[keyname:[^\]]*\]/ /g; # bug

s/(\[keyname:shift_.\])?:/COLON /g;

#print STDERR $_;

s/a/ALFA /g;
s/b/BRAVO /g;
s/c/CHARLIE /g;
s/d/DELTA /g;
s/e/ECHO /g;
s/f/FOXTROT /g;
s/g/GINGER /g;
s/h/HENRY /g;
s/i/INDIA /g;
s/j/JULIET /g;
s/k/KILO /g;
s/l/LIMA /g;
s/m/MICHAEL /g;
s/n/NOVEMBER /g;
s/o/OSCAR /g;
s/p/PETER /g;
s/q/QUEBEC /g;
s/r/ROBBIE /g;
s/s/SIERRA /g;
s/t/TANGO /g;
s/u/UNIFORM /g;
s/v/VICTOR /g;
s/w/WHISKEY /g;
s/x/X-RAY /g;
s/y/YANKEE /g;
s/z/ZULU /g;
s/'/APOSTROPHE /g;
s/((^|[^\dA-Z_])(\d|_)*)8/\1EIGHT /g;
s/((^|[^\dA-Z_])(\d|_)*)5/\1FIVE /g;
s/((^|[^\dA-Z_])(\d|_)*)4/\1FOUR /g;
s/((^|[^\dA-Z_])(\d|_)*)9/\1NINE /g;
s/((^|[^\dA-Z_])(\d|_)*)1/\1ONE /g;
s/((^|[^\dA-Z_])(\d|_)*)7/\1SEVEN /g;
s/((^|[^\dA-Z_])(\d|_)*)6/\1SIX /g;
s/((^|[^\dA-Z_])(\d|_)*)3/\1THREE /g;
s/((^|[^\dA-Z_])(\d|_)*)2/\1TWO /g;
s/((^|[^\dA-Z_])(\d|_)*)0/\1ZERO /g;
s/`/BACKTICK /g;
s/"/QUOTATION /g;
s/\//SLASH /g;
s/,/COMMA /g;
s/:/COLON /g;
s/;/SEMICOLON /g;
s/#/NUMBER_SIGN /g;
s/\./PERIOD /g;
s/\\/BACKSLASH /g;
s/@/AT_SIGN /g;
s/\*/STAR /g;
s/\(/LEFT_PARENS /g;
s/\)/RIGHT_PARENS /g;
s/{/LEFT_BRACE /g;
s/}/RIGHT_BRACE /g;
s/-/DASH /g;
s/=/EQUALS /g;
s/\+/PLUS /g;
s/&/AMPERSAND /g;
s/\^/CIRCUMFLEX /g;
s/\$/DOLLAR_SIGN /g;
s/%/PERCENT /g;
s/!/EXCLAMATION /g;
s/\?/QUESTION /g;
s/~/TWIDDLE /g;
s/\|/VERTICAL_BAR /g;
s/\[/LEFT_BRACKET /g;
s/\]/RIGHT_BRACKET /g;

# bug: [KeyName:F21] as F2 1


s/((?!ERASE)(?!CONTROL)(?!ALTERNATE)(?!SUPER)(?!ENTER_KEY)(?!PAGE)(?!DELETE)(?!HOME_KEY)(?!END_KEY)\b((?!ARROW)\w)+\b +){1,4}ERASE/\nERASE/g;
s/((?!ERASE)(?!CONTROL)(?!ALTERNATE)(?!SUPER)(?!ENTER_KEY)(?!PAGE)(?!DELETE)(?!HOME_KEY)(?!END_KEY)\b((?!ARROW)\w)+\b +){1,4}MISTAKE/\nMISTAKE/g;

s/((?!ERASE)(?!CONTROL)(?!ALTERNATE)(?!SUPER)(?!ENTER_KEY)(?!PAGE)(?!DELETE)(?!HOME_KEY)(?!END_KEY)\b((?!ARROW)\w)+\b +){1,7}ERASE ERASE/\nERASE ERASE/g;
