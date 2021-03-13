/*
https://thormagnusson.gitbooks.io/scoring/content/PartII/chapter11.html
*/

//Main Flute Synth
(
SynthDef("Flute1", { arg scl = 0.2, freq = 442, ipress = 0.9, ibreath = 0.01, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2, vibrato=2.9;
    var kenv1, kenv2, kenvibr, kvibr, sr, cr, block, poly, signalOut, ifqc,  fdbckArray;
    var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;

    sr = SampleRate.ir;
    cr = ControlRate.ir;
    block = cr.reciprocal;
    ifqc = freq;
//	 ifqc = pch;
    // noise envelope
    kenv1 = EnvGen.kr(Env.new(
        [ 0.0, 1.0 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.3, dur - 0.46, 0.2 ], 'linear' )
    );
    // overall envelope
    kenv2 = EnvGen.kr(Env.new(
        [ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
    );
    // vibrato envelope
    kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') )*vibrato;
    // create air flow and vibrato
    aflow1 = LFClipNoise.ar( sr, kenv1 );
    kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );
    asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
    afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;
    fdbckArray = LocalIn.ar( 1 );
    aflute1 = fdbckArray;
    asum2 = asum1 + ( aflute1 * ifeedbk1 );
    //ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
    ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );
    apoly = ax - ( ax.cubed );
    asum3 = apoly + ( aflute1 * ifeedbk2 );
    avalue = LPF.ar( asum3, 2000 );
    aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );
    fdbckArray = [ aflute1 ];
    LocalOut.ar( fdbckArray );
    signalOut = avalue;
    OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );
}).add;
)

// Flute Synth with air effect
(
SynthDef("Flute2", { arg scl = 0.2, freq = 442, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2, vibrato=0.2;
    var kenv1, kenv2, kenvibr, kvibr, sr, cr, block, poly, signalOut, ifqc,  fdbckArray;
    var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;

    sr = SampleRate.ir;
    cr = ControlRate.ir;
    block = cr.reciprocal;
    ifqc = freq;
//	 ifqc = pch;
    // noise envelope
    kenv1 = EnvGen.kr(Env.new(
        [ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
    );
    // overall envelope
    kenv2 = EnvGen.kr(Env.new(
        [ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
    );
    // vibrato envelope
    kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') )*vibrato;
    // create air flow and vibrato
    aflow1 = LFClipNoise.ar( sr, kenv1 );
    kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );
    asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
    afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;
    fdbckArray = LocalIn.ar( 1 );
    aflute1 = fdbckArray;
    asum2 = asum1 + ( aflute1 * ifeedbk1 );
    //ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
    ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );
    apoly = ax - ( ax.cubed );
    asum3 = apoly + ( aflute1 * ifeedbk2 );
    avalue = LPF.ar( asum3, 2000 );
    aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );
    fdbckArray = [ aflute1 ];
    LocalOut.ar( fdbckArray );
    signalOut = avalue;
    OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );
}).add;
)

// Flute Synth just with air
(
SynthDef("Flute3", { arg scl = 0.2, freq = 442, ipress = 0.9, ibreath = 0.5, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 0.8, vibrato=0.4;
    var kenv1, kenv2, kenvibr, kvibr, sr, cr, block, poly, signalOut, ifqc,  fdbckArray;
    var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;

    sr = SampleRate.ir;
    cr = ControlRate.ir;
    block = cr.reciprocal;
    ifqc = freq;
//	 ifqc = pch;
    // noise envelope
    kenv1 = EnvGen.kr(Env.new(
        [ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
    );
    // overall envelope
    kenv2 = EnvGen.kr(Env.new(
        [ 0.0, amp, amp, 0.01 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
    );
    // vibrato envelope
    kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') )*vibrato;
    // create air flow and vibrato
    aflow1 = LFClipNoise.ar( sr, kenv1 );
    kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );
    asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
    afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;
    fdbckArray = LocalIn.ar( 1 );
    aflute1 = fdbckArray;
    asum2 = asum1 + ( aflute1 * ifeedbk1 );
    //ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
    ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );
    apoly = ax - ( ax.cubed );
    asum3 = apoly + ( aflute1 * ifeedbk2 );
    avalue = LPF.ar( asum3, 2000 );
    aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );
    fdbckArray = [ aflute1 ];
    LocalOut.ar( fdbckArray );
    signalOut = avalue;
    OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );
}).add;
)


//Test of synths

Synth("Flute1");
Synth("Flute2");
Synth("Flute3");


/*
https://gist.github.com/iani/d8d6545a172042dfbcd48f67a72cdfe5#file-pbind_score-scd
*/

// Fuction for playing Pbinds automatically

(
~pbplay = { | ... durs |
	var event, process, duration;
	//{
		durs do: { | what, i |
			#duration, event = what.asArray;
			postf("playing % for: %\n", event, duration);
			process = event.play;
			duration.wait;
			process.stop;
		};
		"DONE".postln;
	//}.fork;
};
)

/*
https://stackoverflow.com/questions/31482726/what-is-the-simplest-way-to-play-a-sample-tone-with-given-tempo-in-supercollider
*/

// Metronome + Recording of Metronome 

(
{
Server.default.record;

2.wait;

~bpm = 60;
x = {SinOsc.ar * Pulse.ar(~bpm/60, 0.01).lag}.play;

(8*60). wait;

Server.default.stopRecording;
}.fork;
)


//Playing + recording supercollider's score


(
{
Server.default.record;
1.wait;
(7*4).wait;


~pbplay.( // a short score, of total duration 4 + 3 + 5 = 12 seconds.
	[14*2, Pbind(\instrument, "Flute1", \dur, 1, \note, Pseq([1, 5, \, 11, 8, 2, 0, 10, \, 7, 3, 9, 6, 4],2), \amp, 0.2)],
	8, // pause between phrases. If no pattern is provided, then stay silent.
	[20.5, Pbind(\instrument, "Flute1", \note, Pseq([ \, 25, 29, 35, \, 32, 26, 24, \, 34, 35, 26, 33, 30, 28]),
			\dur,  Pseq([ 1, 1.5, 1/2, 1.5, 1, 1.5, 1/2, 1.5, 1, 3, 2, 2, 1.5, 1/2, 1.5]),
	\amp, 0.4)],
	0.5, // pause m.22 1st tactus
	[1, Pbind(\instrument, "Flute1", \dur, 1/6,\note, Pseq([28,18, 21, 27, 19, 22]),\amp, 0.2)],
	1,	// pause m.22 3rd tactus
	[1, Pbind(\instrument, "Flute1", \dur, 1/6,\note, Pseq([22,19, 27, 21, 18, 28]),\amp, 0.2)]
);


8.wait;

Server.default.stopRecording;
}.fork;
)




//Notes

Pbind(\instrument, "Flute1", \dur, 1,\note, Pseq([1, 5, \, 11, 8, 2, 0, 10, \, 7, 3, 9, 6, 4], 3),\amp, 0.2).play;
14.wait;
Pbind(\instrument, "Flute1", \dur, 1, \vibrato, Prand([0.01,3],inf), \note, Pseq([1, 5, \, 11, 8, 2, 0, 10, \, 7, 3, 9, 6, 4], 3),\amp, 0.2).play;
2.wait;
Pbind(\dur, 1, \note, Pseq([4, 6, 9, 3, 7, 10, 0, 2, 8, 11, 5, 1], 3), \amp, 0.2).play;
4.wait;
Pbind(\dur, 2, \note, Pseq([1, -3, -9, -6, 0, 2, -8, -5, -1, -7, -4, -2], 3), \amp, 0.2).play;
0.5.wait;
Pbind(\dur, 2, \note, Pseq([-2, -4, -7, -1, -5, -8, 2, 0, -6, -9, -3, 1], 3), \amp, 0.2).play;
10.wait;



(
Pbind(
	\instrument, "Flute1",
	\note, Pseq([ \, 25, 29, 35, \, 32, 26, 24, \, 34, 35, 26, 33, 30, 28]),
	\dur,  Pseq([ 1, 1.5, 1/2, 1.5, 1, 1.5, 1/2, 1.5, 1, 3, 2, 2, 1.5, 1/2, 1.5]),
	\amp, 0.2).play;
14.wait;
Pbind(
	\instrument, "Flute1",
	\dur, 1,
	\vibrato, Prand([0.01,3],inf),
	\note, Pseq([1, 5, \, 11, 8, 2, 0, 10, \, 7, 3, 9, 6, 4], 3),
	\amp, 0.2).play;
)

	Pbind(\instrument, "Flute1", \dur, 1/6, \note, Pseq([28, 18, 21, 27,19, 22]).play;



		Pbind(\instrument, "Flute1", \dur, 1/6,\note, Pseq([28,18, 21, 27, 19, 22]),\amp, 0.2).play;








