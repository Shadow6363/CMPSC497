#!/usr/bin/perl
use strict;
use warnings;

open(my $fh, "<", "user_dialogue_c_01.txt")
    or die "Unable to open file, $!";

my $party_size = 1;
my @party_drinks = ();
my @party_orders = ();

my $person_no = 1;

print "Hi, how many are in your party?\n";

while(my $line = <$fh>) {
    print $line;

    $line =~ s/I'm/I am/g;
    $line =~ s/[yY]ou're/you are/g;
    $line =~ s/[wW]e're/we are/g;
    $line =~ s/[tT]hey're/they are/g;
    $line =~ s/[eE]verybody/everyone/g;

    if($line =~ m/.*([1-9][0-9]*).*/) {
        $party_size = $1 + 0;

        if($party_size > 9) {
            print "I'm sorry, we can only take parties of 9 or fewer tonight due to a wedding.\n";

            last;
        } else {
            #sleep(1);

            print "My name is Eliza.\n";
            print "I'll be serving you tonight.\n";
            print "Is there anything I can get you to drink?\n";
        }
    } elsif($line =~ m/.*\b([sS]oda|[wW]ater|[bB]eer|[wW]ine)\b.*/) {
        push(@party_drinks, $1);

        if($person_no < $party_size) {
            $person_no = $person_no + 1;
        } else {
            $person_no = 1;

            if($party_size > 1) {
                print "Alright, I'll be right back with those.\n";
            } else {
                print "Alright, I'll be right back with that.\n";
            }

            #sleep(1);
            foreach(@party_drinks) {
                my $drink = lc($_);
                print "Here's your $drink.\n";
            }

            print "Have you decided what you'd like to eat?\n";
        }
    } elsif($line =~ m/.*\b([yY]es|[nN]o|[nN]ot yet|think so)\b.*/) {
        if(lc($1) eq "yes" or lc($1) eq "think so") {
            print "What would you like?\n";
        } else {
            print "Alright, I'll give you a few.\n";
            #sleep(1);
            print "How about now?\n";
        }
    } elsif($line =~ m/.*\b[rR]ecommend\b.*/) {
        print "Our blackened salmon is well-liked.\n";
    } elsif($line =~ m/.*\b([sS]paghetti|[sS]almon|[lL]obster|[pP]izza|[tT]hat)\b.*/) {
        if(lc($1) eq "that") {
            push(@party_orders, "salmon");
        } else {
            push(@party_orders, $1);
        }

        if($person_no < $party_size) {
            $person_no = $person_no + 1;
        } else {
            $person_no = 1;

            if($party_size > 1) {
                print "Sounds good. I'll get those to you as soon as they're out.\n";
            } else {
                print "Sounds good. I'll get that to you as soon as it's out.\n";
            }

            #sleep(1);
            foreach(@party_orders) {
                my $order = lc($_);
                print "Here's your $order.\n";
                if($order eq "pizza") {
                    print "Be careful, it's right out of the oven and very hot.\n";
                }
            }

            #sleep(1);
            print "Can I get you anything else?\n";
        }
    } elsif($line =~ m/.*\brefill.*/) {
        print "Sure thing.\n";

        #sleep(1);
        print "Can I get you anything else?\n";
    } elsif($line =~ m/.*([aA]ll together|[aA]ltogether|[sS]ingle|[sS]eparate).*/) {
        if(lc($1) eq "separate") {
            print "Here are your checks.\n";
        } else {
            print "Here's your check.\n";

            last;
        }

        print "Have a good night!\n";
    } elsif($line =~ m/.*\bcheck.*/) {
        if($party_size > 1) {
            print "Would you like a single check or separate?\n";
        } else {
            print "I'll be right back with it.\n";
            #sleep(1);
            print "Alright, have a good night!\n";

            last;
        }
    }
}

close($fh)
    or warn "Unable to close file, $!";