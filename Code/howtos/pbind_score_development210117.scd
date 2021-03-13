//: 16 Jan 2021 14:47
/* building a simple prototype of a score for playing 
Pbinds in a sequence of specified durations.

See also file pbind_score_prototype210117.scd for just the finished
code with 2 examples.

*/
// ================================================================
//:play an array of durations sequentially
// developing the algorithm step-by-step.
//:Iterate over the durations (with waiting).
~pbplay = { | ... durs |
	{
		durs do: { | dur, i |
			postf("my % duration is: %\n", i, dur);
		}
	}.fork;
};
~pbplay.(4, 2, 3);
//:Add waiting
~pbplay = { | ... durs |
	{
		durs do: { | dur, i |
			postf("my % duration is: %\n", i, dur);
			dur.wait;
		};
		"DONE".postln;
	}.fork;
};
~pbplay.(0.4, 0.9, 0.3);
//:Add something to play at each step
// NOTE: THIS IMPLEMENTATION CAN PLAY Pbinds in sequence.
~pbplay = { | ... durs |
	var event, process, duration;
	{
		durs do: { | what, i |
			#duration, event = what.asArray;
			postf("playing % for: %\n", event, duration);
			process = event.play;
			duration.wait;
			process.stop;
		};
		"DONE".postln;
	}.fork;
};
// example of a score
a = ~pbplay.(
	[4, Pbind(\dur, 0.02, \degree, Pbrown(-1, 10, 0.1), \amp, 0.5)],
	3, // pause between phrases. If no pattern is provided, then stay silent.
	[5, Pbind(\dur, 0.05, \midinote, Pwhite(40, 100), \amp, 0.5)]
);

