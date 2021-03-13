(midinote: 60.5, dur: 0.5).play;

(
{
	(40, 47 .. 70) do: { | qtone |
		(midinote: qtone, dur: 0.1).play;
		0.1.wait;
	};

}.fork;
)

(
Pbind(
	\midinote, Pseq((40..70)),
	\dur, 0.1
).play;
)

//:

(
Pbind(
	\midinote, Pbrown(40, 70, 2) * 3 - 60,
	\dur, 0.05
).play;
)

//:

(
Pbind(
	\midinote, Pbrown(0, 24, 1) + [45, 46],
	\dur, 0.05
).play;
)

(
Pbind(
	\midinote,
	Pbrown(0, 24, 1) +
	Prand([45, [45, 46], [45, 47, 50]], inf),
	\dur, 0.1
).play;
)

(
Pbind(
	\midinote,
	Pbrown(0, 24, 1) +
	Prand([45, [45, 46], [45, 47, 50]], inf),
	\dur, 0.1
).play;
)

(
~chords = Pbind(
    \dur,Pwhite(4.5,7.0,inf),
    \degree,Pwrand([[0,2,4],[3,5,7],[4,6,8]],[0.5,0.25,0.25],inf),
    \octave,Pwrand([4,3,5],[0.6,0.3,0.1],inf)
    );
)

(
~chords = Pbind(
    \dur, Pwhite(4.5,7.0,inf),
    \degree, Pwrand([[0,2,4],[3,5,7],[4,6,8]], [0.5,0.25,0.25],inf),
    \octave,Pwrand([4,3,5],[6, 3, 1].normalizeSum,inf)
    );
~chords.play;
)

(
~chords = Pbind(
	\dur, Pwhite(4.5,7.0,inf) * Pwrand([1, 0.05], [1, 10].normalizeSum, inf),
    \degree, Pwrand([[0,2,4],[3,5,7],[4,6,8]], [0.5,0.25,0.25],inf),
    \octave,Pwrand([4,3,5],[6, 3, 1].normalizeSum,inf)
    );
~chords.play;
)

(
~chords = Pbind(
	\dur, Pwhite(4.5,7.0,inf) * Pstutter(10, Pseq([1, 0.05], inf)),
    \degree, Pwrand([[0,2,4],[3,5,7],[4,6,8]], [0.5,0.25,0.25],inf),
    \octave,Pwrand([4,3,5],[6, 3, 1].normalizeSum,inf)
    );
~chords.play;
)

(
~chords = Pbind(
	\dur, Pwhite(4.5,7.0,inf) * Pseq([Pn(1, 3), Pn(0.01, 30)], inf),
    \degree, Pwrand([[0,2,4],[3,5,7],[4,6,8]], [0.5,0.25,0.25],inf),
    \octave,Pwrand([4,3,5],[6, 3, 1].normalizeSum,inf)
    );
~chords.play;
)

/*
http://fomus.sourceforge.net/
https://github.com/smoge/superfomus

From THMO MUSICAL INSTRUMENTS to Everyone: (4:45 PM)

(
a = 12.collect({|i|
  ( 'midinote': (
      (63 + rrand(-6,6.5) + [0,8,13]) ++
      (60 + rrand(-6,6.5) + [0,5,6,9]) ),
    'dur': 1 )
});

f = Fomus();
f.fileName = "~/SCFomus_"; // complete file path
f.add(a);
f.ly;
)

*/






[10, 2, 1].normalizeSum;


[0.5,0.25,0.9].normalizeSum;

~chords.play;






(midinote: 45, dur: 0.05).play;

(midinote: [45, 48], dur: 0.05).play;

(midinote: [45, 48] + -5, dur: 0.05).play;

[45, 48] + 5;




45

