#!/usr/bin/perl

#use strict;
use warnings;

use List::Util qw(min);

sub levenshtein {
    my ($str1, $str2) = @_;
    my @ar1 = split //, $str1;
    my @ar2 = split //, $str2;

    my @dist;
    $dist[$_][0] = $_ foreach (0 .. @ar1);
    $dist[0][$_] = $_ foreach (0 .. @ar2);

    foreach my $i (1 .. @ar1){
        foreach my $j (1 .. @ar2){
            my $cost = $ar1[$i - 1] eq $ar2[$j - 1] ? 0 : 2;
            $dist[$i][$j] = min(
                        $dist[$i - 1][$j] + 1,
                        $dist[$i][$j - 1] + 1,
                        $dist[$i - 1][$j - 1] + $cost );
        }
    }

    return $dist[@ar1][@ar2];
}

my %dictionary;

open(my $fh, "<", "wordlist.txt")
    or die "Unable to open file, $!";

while (my $word = <$fh>) {
    chomp($word);
    $dictionary{$word} = 99999;
}

close($fh)
    or warn "Unable to close file, $!";


open($fh, "<", "misspellings.txt")
    or die "Unable to open file, $!";

while (my $word = <$fh>) {
    chomp($word);
    if (not exists $dictionary{$word}) {
        @top_words = ("0", "1", "2");
        %top_word_distances = (
            "0" => 9999999,
            "1" => 9999999,
            "2" => 9999999
        );

        foreach my $key (keys %dictionary) {
            if (abs(length($key) - length($word)) <= $top_word_distances{$top_words[2]}) {
                $distance = levenshtein($word, $key);
                if ($distance < $top_word_distances{$top_words[2]}) {
                    delete $top_word_distances{$top_words[2]};
                    $top_word_distances{$key} = $distance;
                    @top_words = (sort { $top_word_distances{$a} <=> $top_word_distances{$b} } keys %top_word_distances);
                }
            }
        }

        print "Misspelled: $word; Suggested: ";
        print %top_word_distances;
        print"\n";
    }
}

close($fh)
    or warn "Unable to close file, $!";
