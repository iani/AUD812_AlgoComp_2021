//: 20 Dec 2020 07:17 Array how to's
//:Reverse the order of elements in an array
a = (1..5);
a.reverse;
a; // does not change the original array
//:Reverse the order of elements in an array and its subarrays
a = [(1..5), 100, (20..15), 1000];
a.collect({ | a | if (a respondsTo: \reverse) { a.reverse } { a }}).reverse;
//:Invert values by mirroring vertically (like in Bach 'in contrario motu');
a = (1..5);
b = 6;
b - a;
//:Like above, but use * instead of -
a = (1..5).pyramid(1);
a * -1;
//:How to adjust the position of the resultig inversion?
a = (1..5).pyramid(1);
a * -1 + 6;
//:How to choose the value of b?
a = (1..5) add: -10;
b = 6;
b - a;
