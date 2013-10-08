use lib '..';
use Heap;

my $heap = Heap->new;
my $elem;

use Heap::Elem::Num(NumElem);

foreach $i ( 1..100 ) {
    $elem = NumElem( $i );
    $heap->add( $elem );
}

while( defined( $elem = $heap->extract_top ) ) {
    print "Smallest is ", $elem->val, "\n";
}
