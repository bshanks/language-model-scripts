HOW TO BUILD A LANGUAGE MODEL

Note that this was written a long time ago and may be out of date. Also, although the technique in this document is generally applicable, it is described in terms of the specific language models that I built for the voicekey project.

This document is for developers. It describes the use of some helper scripts in conjunction with CMU's cmuclmtk to build three ARPA-format 3-gram language models suitable for dictation. One of these is the model used in Voice Keyboard's "word" mode, the second is the model used in Voice Keyboard's "keyboard" mode, and the other is the model used in Voice Keyboard's "view" mode.

Although the goal is to provide a cut-and-paste list of commands that take you all the way from raw corpora to final language models, the lists of commands provided here has been cobbled together from various sets of notes and have not yet been tested in their entirety.

The Voice Keyboard distribution includes, in addition to the three language models mentioned above, two "intermediate" language models which were used in the creation of those models; namely, combined_corpus_except_ofcourse_keylogger.arpa and corpus_from_usage.arpa. However, it does not include the text corpora which those models were based on -- this is because that text includes personal information such as my own emails. Therefore, in order to implement the instructions in this document, you'll have to provide your own corpora.

CONTENTS 
* Overview 
* Notes on lm_combine
* Making "word mode" lm -- assuming that corpus_from_usage_clean.txt, combined_corpus_except_ofcourse_keylogger_raw.txt, and combined_curated_vocab are already available 
* Making corpus_from_usage_clean.txt, combined_corpus_except_ofcourse_keylogger_raw.txt, and combined_curated_vocab
* Making the "keyboard mode" lm -- assuming that corpus_from_usage_clean.txt is already available 
* Making the "view mode" lm -- assuming corpus_from_usage_clean.txt is already available 


OVERVIEW

  overview of the overview 
   ----------------------
I created two corpora, "corpus_from_usage.txt" and "combined_corpus_except_ofcourse_keylogger_raw.txt". The former is based on keylogger logs and usage histories of Voice Keyboard. The latter is mostly based on text documents and source code that i have written. 

"keyboard mode" vocabulary was manually specified. "word mode" vocabulary was composed of the union of (lm_giga_20k_vp_3gram and a semiautomatically chosen subset of frequently occurring words in the 2 corpora mentioned above) -- minus words_to_omit.d, plus words_to_add.d.

Using the "word mode" vocabulary, combined_corpus_except_ofcourse_keylogger was "normalized" so that out of vocabulary words were rewritten as sequences of keypress codewords.

A modified version of lm_giga_20k_vp_3gram was created that is compatible with CMU's lm_combine tool.

An ARPA-format language model was created for each corpus, using Witten-Bell smoothing. These 2 language models were combined with each other and with lm_giga_20k_vp_3gram, with weights that favored corpus_from_usage over the other 2 and favored combined_corpus_except_ofcourse_keylogger_raw over lm_giga_20k_vp_3gram. The resulting language model is used as Voice Keyboard's "word mode" language model. 

  Prerequisites
   -----------
Before following the procedure in this file, I created a number of text files containing english text and source code.

The english text files included: 

prog_text_corpus_raw.txt		programming project documentation
prog_text_wiki_corpus_raw.txt		programming project wikis
school_text_corpus_raw.txt		stuff i've written for school
website_corpus_raw.txt			my personal website 

The source code containing files included: pl_corpus_raw.txt, py_corpus_raw.txt, c_corpus_raw.txt, sh_corpus_raw.txt, m_corpus_raw.txt, other_code_corpus_raw.txt

I also ran a keylogger on myself for awhile, producing rawlog-current.txt.

Other sources of training data include shell history (bash_history_corpus_raw.txt) and a transcript of previous Voice Keyboard sessions produced by Voice Keyboard itself (voice-keyboard-log.hyp).

I downloaded lm_giga_20k_vp_3gram from http://www.inference.phy.cam.ac.uk/kv227/lm_giga/ .

  combined_corpus_except_ofcourse_keylogger_raw.txt
   -----------------------------------------------
I filtered subjects and message bodies from my Sent Mail folder into a corpus named sent_mail_subjects_and_message_bodies_corpus_raw.txt. I filtered words from rawlog-current.txt into keylogger_corpus_raw.txt.

For each corpus, i counted the number of occurrences of each word (except for single-characters words other than "i" or "a"). For the command/usage history corpora, i counted only words that my Bash shell interactive command completion recognized. After looking at the wordcounts, i subjectively chose for each corpus a threshold, and discarded all words less common than the threshold. I manually went through the remaining words and discarded some of them (i call this "curating" the vocabulary). I merged all of the corpora except for the keylog and voice-keyboard-log.hyp into combined_corpus_except_ofcourse_keylogger_raw.txt, and merged the corresponding wordcounts into combined_curated_wordcounts. combined_curated_vocab was created as the union of the vocabularies of combined_curated_wordcounts and lm_giga_20k_vp_3gram.

This vocabulary was the starting point for a.vocab (see section "Vocabulary", below). a.vocab was normalized in a few ways for the sake of later compatibility with lm_combine. 

ascii_corpus.pl was run on combined_corpus_except_ofcourse_keylogger_raw.txt, with a.vocab as an argument. The output was put in the file combined_corpus_except_ofcourse_keylogger.txt. ascii_corpus.pl "normalizes" a text so that out of vocabulary words are rewritten as sequences of keypress codewords.




  corpus_from_usage.txt
   -------------------
The keylog was processed using pykeylogger_corpus.pl. From the processed keylog and voice-keyboard-log.hyp i made corpus_from_usage.txt.

  "Word mode" vocabulary
   --------
"word mode" vocabulary was computed according to the following:
* start with combined_curated_vocab
* subtract words listed in words_to_omit.d
* add words listed in words_to_add.d
* subtract words not found in any available pronunciation dictionary

A custom dictionary was created for the "words mode" vocabulary.

  Creation of ARPA language model for "word mode"
   ------------------------------
Each corpus was segmented into utterances (utterance markers were placed at the beginning and end of each line). Using cmuclmtk, an ARPA-format language model was created for each corpus, using Witten-Bell smoothing. The language model contained only the subset of the vocabulary that actually appeared in the corpus.

lm_giga_20k_vp_3gram.arpa was processed to remove words not in the a.vocab vocabulary, and to replace its punctuation vocabulary with Voice Keyboard's. Some normalization was also performed in order to make lm_giga_20k_vp_3gram.arpa compatible with lm_combine.

All 3 corpora (corpus_from_usage.txt, combined_corpus_except_ofcourse_keylogger_raw.txt, lm_giga_20k_vp_3gram) were combined using lm_combine. First lm_giga_20k_vp_3gram and combined_corpus_except_ofcourse_keylogger were combined, with respective weights of 0.25 and 0.75. Then corpus_from_usage was combined with the result, with respective weights of 0.8 and 0.2.

  Creation of ARPA language model for "keyboard mode" and "view mode"
   ------------------------------
"Keyboard mode" vocabulary was manually specified in the file words_to_add.d/keyboard.txt. The vocabulary was converted to upper case. A corpus was created by concatenating the vocabulary with corpus_from_usage_clean. The corpus was segmented into utterances (utterance markers were placed at the beginning and end of each line). Using cmuclmtk, an ARPA-format language model was created for the corpus, using Witten-Bell smoothing.

The "view mode" language model was created similarly.




NOTES ON LM_COMBINE

lm_combine is very picky. Both of the input language models should satisfy the following properties (these were figured out by trial and error, i may be wrong):
* <UNK> should be the first 1-gram (note the case)
* there should be no <UNK> throughout the file except for the first 1-gram
* the utterance markers should be <s> and </s> (note the case)
* the ngrams should be sorted by native byte ordering 
* no ngram should be repeated
* i don't quite remember, but i think that none of the backoff probabilities can be greater than 0. You'd think this would never happen, but i think i got that to happen somehow; perhaps by having words in the vocabulary which were never observed, combined with a certain type of smoothing, or perhaps a certain type of smoothing combined with use of the -context flag, either in lm_combined or idngram2lm.

Unfortunately, if any of these conditions are violated, often the error message does not reflect the underlying problem. Very often, the error message will simply claim that an ngram was repeated, even if the actual problem was one of these other things.

Actually, some of these are things that lm3g2dmp is picky about rather than lm_combine. i can't remember who is picky about what.


PROCEDURES

The initial section below assumes that the corpora "corpus_from_usage_clean.txt" and "combined_corpus_except_ofcourse_keylogger_raw.txt" are already available, as well as "combined_curated_vocab", the vocabulary list for the "words" mode. Later on i will show how these were generated.

  THE MAIN PROCEDURE (follow this to rebuild "word mode" language model after vocabulary changes)

  Prerequisites
   ----------- 
$MANUAL_VOCAB_PATH/words_to_add.d/keyboard.txt	codewords available in keyboard mode
				
makeDict.pl			script to create a custom pronuciation dictionary for a vocabulary 

$DICT_PATH/cmudict, $DICT_PATH/handdict,		various dictionaries mapping words to pronuciation
$DICT_PATH/toobig_handdict.dic,
$LM_GIGA_PATH/
   lm_giga_20k_vp.sphinx.dic
		
$CORPUS_PATH/corpus_from_usage_clean.txt
$CORPUS_PATH/combined_corpus_except_ofcourse_keylogger_raw.txt
$LM_GIGA_PATH/lm_giga_20k_vp_3gram.arpa

$CORPUS_PATH/combined_curated_vocab		the initial vocabulary list for the "words" mode
				
$MANUAL_VOCAB_PATH/words_to_omit.d/*.txt		words to subtract from combined_curated_vocab

$MANUAL_VOCAB_PATH/words_to_add.d/*.txt		words to add (applied after words_to_omit.d)

setdiff				script to calculate set difference 

map_vocab			script to map lm_giga punctuation vocabulary to Voice Keyboard codewords 

cmuclmtk			CMU's language model tool kit

set_intersection		script to calculate set intersection 

lm_combine_workaround		script to make an lm_giga language model compatible with lm_combine

lm_omit_words			script to delete lines containing certain words from a language model

lm_fix_ngram_counts		script to recalculate the ngram counts at the beginning of a ARPA-format 3-gram lm

lm3g2dmp			CMU's program to create a .DMP file from an ARPA-format ngram language model



  The procedure
   -----------
DICT_PATH=..
LM_GIGA_PATH=../lm_giga_20k_vp_3gram
CORPUS_PATH=.
MANUAL_VOCAB_PATH=.

#####
##### began creating vocabulary list a.vocab, omitting words not found in any dictionary 
#####

cat $MANUAL_VOCAB_PATH/words_to_omit.d/*.txt > words_to_omit

setdiff $CORPUS_PATH/combined_curated_vocab words_to_omit  > a.vocab

cat a.vocab $MANUAL_VOCAB_PATH/words_to_add.d/*.txt   > a.vocab2
perl -e 'undef $/; $_=<>; print uc;' a.vocab2 > a.vocab
map_vocab a.vocab 
makeDict.pl a $DICT_PATH/cmudict $DICT_PATH/handdict $DICT_PATH/toobig_handdict.dic $LM_GIGA_PATH/lm_giga_20k_vp.sphinx.dic;

setdiff a.vocab a.notfound  > a.vocab2
mv -f a.vocab2 a.vocab

#####
##### make sure words_to_omit doesn't contain any words in the vocabulary 
#####


setdiff words_to_omit a.vocab   > words_to_omit2  
mv -f words_to_omit2 words_to_omit   # now words_to_omit doesn't contain any words in words_to_add..
                                     # this is necessary b/c we will use it below to take words out of the vocab

#####
##### ensure list is upper case, contains <s>, </s>, is sorted. create a.dic
#####

perl -e 'undef $/; $_=<>; print uc;' a.vocab > a.vocab2
perl -e 's/<S>/begin_utterance/g; s/<\/S>/end_utterance/g; ' -pi a.vocab
perl -e 's/begin_utterance/<s>/g; s/end_utterance/<\/s>/g; ' -pi a.vocab
echo $'<s>\n</s>' | cat - a.vocab > a2.vocab
mv -f a2.vocab a.vocab 
cat a.vocab | text2wfreq | wfreq2vocab -top 10000000 > a.vocab2; # do this to resort the word ordering, because
                                                                 # lm_combine requires the words to be sorted a certain way
mv -f a.vocab2 a.vocab 

makeDict.pl a $DICT_PATH/cmudict $DICT_PATH/handdict $DICT_PATH/toobig_handdict.dic $LM_GIGA_PATH/lm_giga_20k_vp.sphinx.dic;

#####
##### create combined_corpus_except_ofcourse_keylogger.txt from combined_corpus_except_ofcourse_keylogger_raw.txt
##### and vocabulary 
#####

ascii_corpus.pl a.vocab  $CORPUS_PATH/combined_corpus_except_ofcourse_keylogger_raw.txt  combined_corpus_except_ofcourse_keylogger.txt

perl -e 'undef $/; $_=<>; print uc;' combined_corpus_except_ofcourse_keylogger.txt  > combined_corpus_except_ofcourse_keylogger_clean.txt 


 # the following stanza may be unnecessary 
 perl -e 's/(?!\n)[[:^ascii:][:cntrl:]]//g;' -pi combined_corpus_except_ofcourse_keylogger_clean.txt
 perl -e 's/(^|(?<= ))_//g;' -pi combined_corpus_except_ofcourse_keylogger_clean.txt  #bugs in pykeylogger processing...
 perl -e 's/(^|(?<= ))\d+\w+//g;' -pi combined_corpus_except_ofcourse_keylogger_clean.txt  #bugs in pykeylogger processing...
 perl -e 's/F1//g;' -pi combined_corpus_except_ofcourse_keylogger_clean.txt  #bug in ascii_unweighted_corpus processing...
 perl -e 's/XDASH/X-RAY/g;' -pi combined_corpus_except_ofcourse_keylogger_clean.txt  #bugs in pykeylogger processing...
 

#####
##### segment corpora into sentences 
#####

perl -e 'undef $/; $_=<>; s/^\s*\n//mg; print' combined_corpus_except_ofcourse_keylogger_clean.txt > combined_corpus_except_ofcourse_keylogger_with_sentences.txt; perl -e 's/^[ \t]*/<s> /; s/[ \t]*$/ <\/s>/;' -pi combined_corpus_except_ofcourse_keylogger_with_sentences.txt; 
perl -e 'undef $/; $_=<>; s/^\s*\n//mg; print' $CORPUS_PATH/corpus_from_usage_clean.txt > corpus_from_usage_with_sentences.txt; perl -e 's/^[ \t]*/<s> /; s/[ \t]*$/ <\/s>/;' -pi corpus_from_usage_with_sentences.txt; 

perl -e 's/<S>/<s>/g; s/<\/S>/<\/s>/g; ' -pi combined_corpus_except_ofcourse_keylogger_with_sentences.txt
perl -e 's/<S>/<s>/g; s/<\/S>/<\/s>/g; ' -pi corpus_from_usage_with_sentences.txt


#####
##### for each corpus, create vocabulary list of subset of vocabulary actually appearing in corpus.
#####                  then create ARPA language model (w/ witten-bell smoothing)
#####

cat combined_corpus_except_ofcourse_keylogger_with_sentences.txt | text2wfreq | wfreq2vocab -top 10000000 > combined_corpus_except_ofcourse_keylogger_with_sentences.vocab.1;
set_intersection combined_corpus_except_ofcourse_keylogger_with_sentences.vocab.1 a.vocab > combined_corpus_except_ofcourse_keylogger_with_sentences.vocab
perl -e 's/<S>/<s>/g; s/<\/S>/<\/s>/g; ' -pi combined_corpus_except_ofcourse_keylogger_with_sentences.vocab
cat combined_corpus_except_ofcourse_keylogger_with_sentences.txt | text2idngram -vocab combined_corpus_except_ofcourse_keylogger_with_sentences.vocab | idngram2lm -vocab combined_corpus_except_ofcourse_keylogger_with_sentences.vocab -idngram -    -arpa combined_corpus_except_ofcourse_keylogger.arpa -witten_bell;

# words in the  vocabulary that i never use 
#diff combined_corpus_except_ofcourse_keylogger_with_sentences.vocab a.vocab|less 



cat corpus_from_usage_with_sentences.txt | text2wfreq | wfreq2vocab -top 10000000 > corpus_from_usage_with_sentences.vocab.1;
set_intersection corpus_from_usage_with_sentences.vocab.1 a.vocab > corpus_from_usage_with_sentences.vocab
perl -e 's/<S>/<s>/g; s/<\/S>/<\/s>/g; ' -pi corpus_from_usage_with_sentences.vocab
cat corpus_from_usage_with_sentences.txt | text2idngram -vocab corpus_from_usage_with_sentences.vocab | idngram2lm -vocab corpus_from_usage_with_sentences.vocab -idngram -    -arpa corpus_from_usage.arpa -witten_bell;


#####
##### make lm_giga_20k_vp_3gram.arpa compatible with lm_combine,
##### remove words not in the vocabulary,
##### map punctuation words to our codewords,
##### fix counts and resort.
#####

lm_combine_workaround $LM_GIGA_PATH/lm_giga_20k_vp_3gram.arpa
mv -f $LM_GIGA_PATH/lm_giga_20k_vp_3gram.arpa_only_1gram_UNK.arpa lm_giga_20k_vp_3gram_tmp.arpa


lm_omit_words lm_giga_20k_vp_3gram_tmp.arpa words_to_omit > lm_giga_20k_vp_3gram_tmp.arpa-2
mv -f lm_giga_20k_vp_3gram_tmp.arpa-2 lm_giga_20k_vp_3gram_tmp.arpa
map_vocab lm_giga_20k_vp_3gram_tmp.arpa
lm_omit_words lm_giga_20k_vp_3gram_tmp.arpa words_to_omit > lm_giga_20k_vp_3gram_tmp.arpa-2
mv -f lm_giga_20k_vp_3gram_tmp.arpa-2 lm_giga_20k_vp_3gram_tmp.arpa
lm_fix_ngram_counts lm_giga_20k_vp_3gram_tmp.arpa

csplit lm_giga_20k_vp_3gram_tmp.arpa /^\\\\1-grams:$/-1 // /^\\\\2-grams:$/-1 // /^\\\\3-grams:$/-1 //
(LC_ALL=C; sort -k2,2 xx02>xxs02)
(LC_ALL=C; sort -k2,2 -k3,3 xx04>xxs04)
rm -f xx02 xx04
head -n -2 xx06|(LC_ALL=C; sort -k2,2 -k3,3 -k4,4 >xxs06)
tail -n 2 xx06 |cat xx00 xx01 xxs02 xx03 xxs04 xx05 xxs06 - >lm_giga_20k_vp_3gram_tmp.arpa
rm -f xx00 xx01 xxs02 xx03 xxs04 xx05 xx06 xxs06



lm_combine_workaround lm_giga_20k_vp_3gram_tmp.arpa
mv -f lm_giga_20k_vp_3gram_tmp.arpa_only_1gram_UNK.arpa lm_giga_20k_vp_3gram_only_1gram_UNK.arpa

#####
##### not sure if this is needed 
#####

lm_combine_workaround combined_corpus_except_ofcourse_keylogger.arpa
lm_combine_workaround corpus_from_usage.arpa

mv -f combined_corpus_except_ofcourse_keylogger.arpa_only_1gram_UNK.arpa combined_corpus_except_ofcourse_keylogger_only_1gram_UNK.arpa
mv -f corpus_from_usage.arpa_only_1gram_UNK.arpa corpus_from_usage_only_1gram_UNK.arpa 

#####
##### combine all 3 corpora
#####

lm_combine -lm1 lm_giga_20k_vp_3gram_only_1gram_UNK.arpa   -lm2 combined_corpus_except_ofcourse_keylogger_only_1gram_UNK.arpa -weight w0.wt -lm gigaword_and_mycorpus_not_keylogger.arpa

lm_combine -lm1 corpus_from_usage_only_1gram_UNK.arpa -lm2  gigaword_and_mycorpus_not_keylogger.arpa -weight w.wt -lm a.arpa

rm -f gigaword_and_mycorpus_not_keylogger.arpa

#####
##### manually adjust the language model 
#####

perl -e 's/^(.*VOICE KEYBOARD\s+)(-.*)$/${1}0.0000/;' -pi a.arpa

#####
##### leave the lm_combine-able language models in obvious places 
#####

mv -f combined_corpus_except_ofcourse_keylogger_only_1gram_UNK.arpa combined_corpus_except_ofcourse_keylogger.arpa
mv -f corpus_from_usage_only_1gram_UNK.arpa corpus_from_usage.arpa

#####
##### replace the old lm with the new one
#####

perl -e 's/\t/ /g;' -pi a.arpa;
mv -f a.arpa word-vocab.arpa

mv -f a.dic voice-keyboard-current.dic

make




  HOW I MADE CORPUS_FROM_USAGE_CLEAN.TXT, COMBINED_CORPUS_EXCEPT_OFCOURSE_KEYLOGGER_RAW.TXT, COMBINED_CURATED_VOCAB
   ---------------------------------------------------------------------------------------------------------------

     Prerequisites
      -----------
wordcounts					counts number of occurrences of each word 

~/.bash_history

pykeylogger_corpus_words.pl			converts pykeylogger log into a corpus (words only)

pykeylogger_corpus.pl				converts pykeylogger log into a corpus (keypresses converted to codewords)

generate_wordcounts				generates wordcounts from corpora

combine_wordcounts_with_commands		restrict wordcount to commands recognized by shell interactive completion 

filter_single_characters			remove words consisting of a single character, except "i" or "a",
						from wordcounts

filter_top_wordcounts				remove words with less than a specified number of occurrences from wordcounts

pl_corpus_raw.txt, py_corpus_raw.txt,		various corpora
c_corpus_raw.txt, sh_corpus_raw.txt,
m_corpus_raw.txt, other_code_corpus_raw.txt,
prog_text_corpus_raw.txt,
prog_text_wiki_corpus_raw.txt,
school_text_corpus_raw.txt,
website_corpus_raw.txt

~/Mail/.sent-mail				Maildir-format mailbox

$LM_GIGA_PATH/wlist_giga_20k_vp		vocabulary list for lm_giga_20k_vp_3gram

voice-keyboard-log.hyp				transcript of past Voice Keyboard sessions 

$KEYLOG_PATH/rawlog-current.txt			pykeylogger log (or concatenation of logs)

     The procedure
      -----------

LM_GIGA_PATH=../lm_giga_20k_vp_3gram
KEYLOG_PATH=..
SENT_MAIL=~/Mail/.sent-mail

#####
##### unused commands that might be useful 
#####

#wc -w  ${corpus}_corpus_wordcounts
#less ${corpus}_corpus_wordcounts
#tail -n 60 ${corpus}_corpus_wordcounts | less

#####
##### extract subjects and message bodies from Maildir-format mailbox
#####

( find $SENT_MAIL -type f | xargs -n1 perl -MEmail::MIME -e 'sub doPart {$_ = $_[0]; if ($_->content_type =~ "text/plain") {$_ = $_->body; s/^>.*\n//mg; s/^On \w{3}, \w{3} \d+, \d+ at \d\d:\d\d:\d\d\w+ \S+, .* wrote:\n//mg; s/----- Forwarded message from .*//ms; print}}      undef $/; $raw = <>; $m = Email::MIME->new($raw); $s = $m->header("Subject"); if (! ($s =~ /^(Re:|\[Fwd)/)) {print $s . "\n"}; doPart($m); if ($m->subparts) {doPart(($m->subparts)[0]);}' )  > sent_mail_subjects_and_message_bodies_corpus_raw.txt 

#####
##### create corpus from shell history 
#####

cp ~/.bash_history bash_history_corpus_raw.txt

#####
##### create corpus from words in keylogger history 
#####

pykeylogger_corpus_words.pl $KEYLOG_PATH/rawlog-current.txt > keylogger_words_corpus_raw.txt

#####
##### generate wordcounts from corpora
#####

generate_wordcounts pl py c sh m other_code prog_text prog_text_wiki school_text sent_mail_subjects_and_message_bodies website keylogger_words bash_history  
combine_wordcounts_with_commands keylogger_words
combine_wordcounts_with_commands bash_history
filter_single_characters pl py c sh m other_code prog_text prog_text_wiki school_text sent_mail_subjects_and_message_bodies website keylogger_words bash_history

#####
##### throw out uncommon words from each corpus separately
#####

filter_top_wordcounts pl 66
filter_top_wordcounts py 37
filter_top_wordcounts c 40
filter_top_wordcounts sh 5
filter_top_wordcounts m 56
filter_top_wordcounts other_code 14
filter_top_wordcounts prog_text 35
filter_top_wordcounts prog_text_wiki 30 
filter_top_wordcounts school_text 11 
filter_top_wordcounts sent_mail_subjects_and_message_bodies      13
filter_top_wordcounts website 13
filter_top_wordcounts keylogger_words 2
filter_top_wordcounts bash_history 2



list *top_wordcounts*
# begin untested section 
#####
##### combine wordcounts from groups of related corpora
#####

perl -le 'while (<>) {@F = split(" "); $wc{$F[1]} = $wc{$F[1]} + $F[0];} for $key (keys %wc) {print "     $wc{$key} $key"}' pl_corpus_top_wordcounts py_corpus_top_wordcounts sh_corpus_top_wordcounts c_corpus_top_wordcounts m_corpus_top_wordcounts other_code_corpus_top_wordcounts  | sort -n > prog_code_combined_top_wordcounts 




perl -le 'while (<>) {@F = split(" "); $wc{$F[1]} = $wc{$F[1]} + $F[0];} for $key (keys %wc) {print "     $wc{$key} $key"}' bash_history_corpus_top_wordcounts keylogger_words_corpus_top_wordcounts  | sort -n > interactive_shell_combined_top_wordcounts 



perl -le 'while (<>) {@F = split(" "); $wc{$F[1]} = $wc{$F[1]} + $F[0];} for $key (keys %wc) {print "     $wc{$key} $key"}' sent_mail_subjects_and_message_bodies_corpus_top_wordcounts website_corpus_top_wordcounts school_text_corpus_top_wordcounts prog_text_corpus_top_wordcounts prog_text_wiki_corpus_top_wordcounts | sort -n > text_combined_top_wordcounts 


cat pl_corpus_raw.txt py_corpus_raw.txt sh_corpus_raw.txt c_corpus_raw.txt m_corpus_raw.txt other_code_corpus_raw.txt > prog_code_combined_raw.txt 
cat sent_mail_subjects_and_message_bodies_corpus_raw.txt website_corpus_raw.txt school_text_corpus_raw.txt prog_text_corpus_raw.txt prog_text_wiki_corpus_raw.txt > text_combined_raw.txt 

cat prog_code_combined_raw.txt ~/.bash_history text_combined_raw.txt > combined_corpus_except_ofcourse_keylogger_raw.txt




list *combined_top_wordcounts 
wc -w *combined_top_wordcounts 


cp interactive_shell_combined_top_wordcounts interactive_shell_combined_curated_wordcounts
cp prog_code_combined_top_wordcounts prog_code_combined_curated_wordcounts 
cp text_combined_top_wordcounts text_combined_curated_wordcounts

#####
##### using a text editor, manually curate word lists
#####

# now edit them to curate

editor personal_curated_wordcounts
editor interactive_shell_combined_curated_wordcounts 
editor   prog_code_combined_curated_wordcounts 
editor  text_combined_curated_wordcounts

#####
##### more combining
#####

perl -le 'while (<>) {@F = split(" "); $wc{$F[1]} = $wc{$F[1]} + $F[0];} for $key (keys %wc) {print "$wc{$key} $key"}' interactive_shell_combined_curated_wordcounts prog_code_combined_curated_wordcounts  text_combined_curated_wordcounts personal_curated_wordcounts | sort -n > combined_curated_wordcounts

cat sent_mail_subjects_and_message_bodies_corpus_raw.txt website_corpus_raw.txt school_text_corpus_raw.txt prog_text_corpus_raw.txt prog_text_wiki_corpus_raw.txt > text_combined_raw.txt 

cat prog_code_combined_raw.txt ~/.bash_history text_combined_raw.txt > combined_corpus_except_ofcourse_keylogger_raw.txt

#####
##### create corpus_from_usage.txt from keylog and voice-keyboard-log.hyp
#####

perl -e 's/\([^)]*\)//;' -p voice-keyboard-log.hyp > voice-keyboard-log.txt
pykeylogger_corpus.pl $KEYLOG_PATH/rawlog-current.txt | cat words_to_add.d/keyboard.txt voice-keyboard-log.txt - > corpus_from_usage.txt

#####
##### upcase corpus_from_usage.txt and kludgily correct for some bugs in pykeylogger_corpus.pl
#####

perl -e 'undef $/; $_=<>; print uc;' corpus_from_usage.txt > corpus_from_usage_clean.txt

 perl -e 's/(?!\n)[[:^ascii:][:cntrl:]]//g;' -pi corpus_from_usage_clean.txt
 perl -e 's/(^|(?<= ))_//g;' -pi corpus_from_usage_clean.txt  #bugs in pykeylogger processing...
 perl -e 's/(^|(?<= ))\d+\w+//g;' -pi corpus_from_usage_clean.txt  #bugs in pykeylogger processing...

 perl -e 's/F1//g;' -pi corpus_from_usage_clean.txt  #bug in ascii_corpus_from_usage_clean processing...
 perl -e 's/XDASH/X-RAY/g;' -pi corpus_from_usage_clean.txt  #bugs in pykeylogger processing...

#####
##### create vocabulary list from union of words in lm_giga_20k_vp_3gram and combined_curated_wordcounts
#####

perl -lane 'print $F[1]' combined_curated_wordcounts | cat - $LM_GIGA_PATH/wlist_giga_20k_vp > combined_curated_vocab




MAKING THE "KEYBOARD MODE" LANGUAGE MODEL -- assuming corpus_from_usage_clean.txt is available 

DICT_PATH=..
LM_GIGA_PATH=../lm_giga_20k_vp_3gram
CORPUS_PATH=.
MANUAL_VOCAB_PATH=.

# create vocabulary 
cp -f $MANUAL_VOCAB_PATH/words_to_add.d/keyboard.txt keyboard.vocab
# create dictionary 
makeDict.pl keyboard $DICT_PATH/cmudict $DICT_PATH/handdict $DICT_PATH/toobig_handdict.dic $LM_GIGA_PATH/lm_giga_20k_vp.sphinx.dic;

# upcase vocab
perl -e 'undef $/; $_=<>; print uc;' keyboard.vocab > keyboard_clean.txt
# combine vocab with corpus_from_usage_clean to create corpus 
cat keyboard_clean.txt $CORPUS_PATH/corpus_from_usage_clean.txt > keyboard_clean.txt.1
mv -f keyboard_clean.txt.1 keyboard_clean.txt

# add utterance markers 
perl -e 'undef $/; $_=<>; s/^\s*\n//mg; print' keyboard_clean.txt > keyboard_with_sentences.txt; perl -e 's/^[ \t]*/<s> /; s/[ \t]*$/ <\/s>/;' -pi keyboard_with_sentences.txt; 
# downcase utterance markers
perl -e 's/<S>/<s>/g; s/<\/S>/<\/s>/g; ' -pi keyboard_with_sentences.txt

# sort vocab
echo $'<s>\n</s>' | cat - keyboard.vocab | text2wfreq | wfreq2vocab -top 10000000 > keyboard_with_sentences.vocab;
# create ARPA lm
cat keyboard_with_sentences.txt | text2idngram -vocab keyboard_with_sentences.vocab | idngram2lm -vocab keyboard_with_sentences.vocab -idngram -    -arpa keyboard.arpa -witten_bell;

# replaced old lm with new one
perl -e 's/\t/ /g;' -pi keyboard.arpa;
mv -f keyboard.arpa keyboard-vocab.arpa

mv -f keyboard.dic keyboard-vocab.dic

make


MAKING THE "VIEW MODE" LANGUAGE MODEL -- assuming corpus_from_usage_clean.txt is available 

Almost the same as keyboard mode -- just replace the word "keyboard" in the above with "view", and replace the first line with 

       cp words_to_add.d/view.txt view.vocab
