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


#s/((?!ERASE)(?!CONTROL)(?!ALTERNATE)(?!SUPER)(?!ENTER_KEY)(?!PAGE)(?!DELETE)(?!HOME_KEY)(?!END_KEY)\b((?!ARROW)\w)+\b +){1,4}ERASE/\nERASE/g;
#s/((?!ERASE)(?!CONTROL)(?!ALTERNATE)(?!SUPER)(?!ENTER_KEY)(?!PAGE)(?!DELETE)(?!HOME_KEY)(?!END_KEY)\b((?!ARROW)\w)+\b +){1,4}MISTAKE/\nMISTAKE/g;

#s/((?!ERASE)(?!CONTROL)(?!ALTERNATE)(?!SUPER)(?!ENTER_KEY)(?!PAGE)(?!DELETE)(?!HOME_KEY)(?!END_KEY)\b((?!ARROW)\w)+\b +){1,7}ERASE ERASE/\nERASE ERASE/g;

s/\[keyname:[^\]]+\]/\n/g;
s/[^a-zA-Z0-9_\-]/\n/g;
