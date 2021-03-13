//: 16 Jan 2021 20:50
/* Sum all values produced by a pattern.
Useful for calculating the total duration of a pattern, if that pattern
is to be used as 'dur' key in pbind.

Conditions: The pattern must be finite and contain only deterministic elements (no Pwhite, Pbrown, Prand or similar random patterns).

To prevent infinite loops on patterns of infinite length the function 
will get up to 1000000 elements.  This value can be changed by passing a different
value to the second argument: "limit".

*/
//:
(
~patSum = { | pattern, limit = 1000000 |
	var stream, values, currentvalue, count = 0;
	stream = pattern.asStream;
	while {
		((currentvalue = stream.next).notNil and: {
			(count) < limit			
		})
	}{  // asFloat: Permit representation of larger numbers than Integer.
		values = values add: currentvalue.asFloat;
		count = count + 1;
	};
	values.sum;
}
)
//: Tests:
~patSum.(Pseq([1, 2, 3, 6]));
//:
~patSum.(Pseries(1, 1, 10));
//:
~patSum.(Pn(0.5, 10));
//:
(3..9) do: { | i |
~patSum.(Pseries(1, 1, (10**i).postln)).postln;
}
//:alternative coding of sum
(
~patSum2 = { | pattern, limit = 1000000 |
	var stream, dur = 0.0, currentvalue, count = 0;
	stream = pattern.asStream;
	while {
		((currentvalue = stream.next).notNil and: {
			(count) < limit			
		})
	}{
		dur = dur + currentvalue;
		count = count + 1;
	};
	dur
}
)
//: Tests of alternative version:
~patSum2.(Pseq([1, 2, 3, 6]));
//:
~patSum2.(Pseries(1, 1, 10));
//:
~patSum2.(Pn(0.5, 10));
//:
(3..9) do: { | i |
~patSum2.(Pseries(1, 1, (10**i).postln)).postln;
}


