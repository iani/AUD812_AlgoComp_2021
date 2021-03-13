//: 16 Jan 2021 15:35
/* 
Simple function for playing a timed sequence of pbinds, with example.

In 2 steps:
1. Define the function for playing pbinds.
2. Use the function for playing a sequence of pbinds

Note that once the function has been defined and stored, 
it can be used any number of times to play different scores.
*/

// Define and store the function for playing:
(
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
)
//: An example using the function above:
(
~pbplay.( // a short score, of total duration 4 + 3 + 5 = 12 seconds.
	[4, Pbind(\dur, 0.02, \degree, Pbrown(-1, 10, 0.1), \amp, 0.5)],
	3, // pause between phrases. If no pattern is provided, then stay silent.
	[5, Pbind(\dur, Prand([0.15, Pn(0.05, 5)], inf), \midinote, Pwhite(20, 25) * 4, \amp, 0.5)]
);
)

//: Second example using the function above.
/* This one repeats the score forever, in overlapping segments,
	and with randomly varying duration and frequency parameters
*/
(
{
	loop {
		~pbplay.(
			[4, Pbind(\dur, 0.02.rrand(0.1),
				\degree, Pbrown(-1, 10, 0.1.rrand(2)), \amp, 0.5)],
			3, // pause between phrases. If no pattern is provided, then stay silent.
			[5, Pbind(\dur,
				Prand([0.15, Pn(0.05.rrand(0.5), 5.rrand(12))], inf),
				\midinote, Pwhite(20, 25) * 2.rrand(7), \amp, 0.5)
			];
		);
		5.rrand(12).wait;
	}
}.fork
)
