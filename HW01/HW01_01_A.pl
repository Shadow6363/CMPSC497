#!/usr/bin/perl
use strict;
use warnings;

=begin comment

Rules:

m/.*alike.*/
Lines containing "alike" =>
    "In what way?".

m/.*like.*/
Lines containing "like" =>
    "What resemblance do you see?".

m/My[ ](mother|father|brother|sister|son|daughter)[ ](.*)[ ]me.*/
Lines of the form "My <family member> <verb phrase> me." =>
    "Who else <verb phrase> of you?".

=end comment
=cut

open(my $fh, "<", "user_dialogue_a_02.txt")
    or die "Unable to open file, $!";

my $am_switch = 0;
my $am_memory = "here";

while (my $line = <$fh>) {
    print $line;

    $line =~ s/I'm/I am/g;
    $line =~ s/[yY]ou're/you are/g;
    $line =~ s/[wW]e're/we are/g;
    $line =~ s/[tT]hey're/they are/g;
    $line =~ s/[eE]verybody/everyone/g;

    if ($line =~ m/.*alike.*/) {
        print "In what way?\n";
    } elsif ($line =~ m/.*like.*/) {
        print "What resemblance do you see?\n";
    } elsif ($line =~ m/My[ ](mother|father|brother|sister|son|daughter)[ ](.*)[ ]me.*/) {
        print "Who else $2 of you?\n";
    } elsif ($line =~ m/.*[mM]y[ ](.*)[ ]me[ ](.*)\./) {
        print "Why do you think your $1 you $2?\n";
    } elsif ($line =~ m/^My[ ](.*)\.$/) {
        print "Your $1?\n";
    } elsif ($line =~ m/.*something.*/) {
        print "Can you think of a specific example?\n";
    } elsif ($line =~ m/.*[ ]my[ ](.*)[ ]me[ ](.*)\./) {
        print "Your $1 you $2?\n";
    } elsif ($line =~ m/.*I[ ](am|wouldn't be)[ ](\w+).*\./) {
        $am_memory = $2;

        if ($am_switch == 0) {
            print "I'm sorry to hear you're $am_memory.\n";
            $am_switch = 1;
        } else {
            print "Do you think coming here will help you not to be $am_memory?\n";
            $am_switch = 0;
        }
    } elsif ($line =~ m/.*I need(ed)? ([\w\s]+)[^\s\w]*/) {
        print "What would it mean to you if you got $2?\n";
    } elsif ($line =~ m/.*(mother|father|brother|sister|son|daughter).*/) {
        print "Tell me more about your family.\n";
    } else {
        if ($am_switch == 0) {
            print "Can you elaborate on why you think you're $am_memory?\n";
            $am_switch = 1;
        } else {
            print "Why do you say that?\n";
            $am_switch = 0;
        }
    }
}

close($fh)
    or warn "Unable to close file, $!";