//: see https://www.youtube.com/watch?v=ESCbw9Ph9m4&list=RDZnObqYfb-0M&index=13

Pbind(\dur, 0.2, \degree, Pseq([0, 1, 2, 1, 0], 1), \amp, 0.2).play;

//:For brevity and reference, put the pattern in a variable and use that.
~pat1 = Pseq([0, 1, 2, 1, 0], 1);
//:transpose the pattern: use + operator.
// SIMPLE!!!!! ;-)
Pbind(\dur, 0.2, \degree, ~pat1 + 4, \amp, 0.2).play;
//: play the 2 in sequence
Pbind(\dur, 0.2, \degree, Pseq([~pat1, ~pat1 + 4]), \amp, 0.2).play;
//: play the 2 in sequence, insert a pause for clarity
Pbind(\dur, 0.2, \degree, Pseq([~pat1, \, \, ~pat1 + 4]), \amp, 0.2).play;
//: play the 3 transpositions: Sa, Pa, Ṡa
Pbind(\dur, 0.2, \degree, Pseq([~pat1, \, \, ~pat1 + 4, \, \, ~pat1 + 7]), \amp, 0.2).play;
//:example of making a new scale
Scale.all.put(\catastrophic, Scale([0, 0.1, 0.4, 11.2]));
//:Raga Mayamalavagoula
Scale.all.put(\mayamalavagoula, Scale([0, 1, 4, 5, 7, 8, 11]));
//:play he above example in Raga Mayamalavagoula
Pbind(\dur, 0.5, \degree, Pseq([~pat1, \, \, ~pat1 + 4, \, \, ~pat1 + 7]), \amp, 0.2,
	\scale, Scale.mayamalavagoula
).play;
//:Add duration pattern to the above example
~durs = Pseq([0.25, 0.25, 0.25, 0.25, 0.75], inf);
Pbind(\dur, ~durs, \degree, Pseq([~pat1, ~pat1 + 4, ~pat1 + 7]), \amp, 0.2,
	\scale, Scale.mayamalavagoula
).play;
