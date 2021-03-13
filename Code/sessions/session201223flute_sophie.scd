
/*
https://thormagnusson.gitbooks.io/scoring/content/PartII/chapter11.html
*/

(
SynthDef("waveguideFlute", { arg scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2, vibrato=0.2;
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

Synth("waveguideFlute");

Pbind(\instrument, "waveguideFlute", \dur, 0.1, \note, Pseq([1, 5, \, 11, 8, 2, 0, 10, \, 7, 3, 9, 6, 4], 3),	\amp, 0.2).play;

Pbind(\dur, 1, \note, Pseq([4, 6, 9, 3, 7, 10, 0, 2, 8, 11, 5, 1], 3), \amp, 0.2).play;

Pbind(\dur, 2, \note, Pseq([1, -3, -9, -6, 0, 2, -8, -5, -1, -7, -4, -2], 3), \amp, 0.2).play;

Pbind(\dur, 2, \note, Pseq([-2, -4, -7, -1, -5, -8, 2, 0, -6, -9, -3, 1], 3), \amp, 0.2).play; 