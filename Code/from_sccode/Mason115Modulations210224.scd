//: 24 Feb 2021 13:01
/*
From: https://sccode.org/1-55i

«Mason 115 Modulations» by Mason McCormack
on 15 Nov'16 15:07 in 115modulations

https://soundcloud.com/macdaddymase/song-2

*/

(
SynthDef("am1", {arg freq = 440, modfreq = 2, amp = 0.2, att = 0.01, rel = 3;
    var carrier, modulator, env;
    env = Env.perc(
        attackTime: att,
        releaseTime: rel,
        level: amp
    ).kr(2);
    modulator = SinOsc.ar(modfreq).range(0, 1);
    carrier = SinOsc.ar(freq: freq, mul: env * modulator);
    Out.ar(0, carrier ! 2);
}).add;

SynthDef("am2", {arg freq = 440, modfreq = 2, amp = 0.2, att = 0.01, sus = 0.2, rel = 3, gate = 1, pos = 0;
    var carrier, modulator, env;
    env = Env.asr(
        attackTime: att,
		sustainLevel: sus,
        releaseTime: rel
	).kr(doneAction: 2, gate: gate, mul: amp);
    modulator = SinOsc.ar(modfreq).range(0, 1);
    carrier = SinOsc.ar(freq: freq, mul: env * modulator);
	Out.ar(0, Pan2.ar(carrier, pos));
}).add;

SynthDef("am3", {arg freq = 440, modfreq = 2, amp = 0.2, att = 0.01, sus = 0.2, rel = 3, gate = 1, pos = 0;
    var carrier, modulator, env;
    env = Env.asr(
        attackTime: att,
		sustainLevel: sus,
        releaseTime: rel
	).kr(doneAction: 2, gate: gate, mul: amp);
    modulator = SinOsc.ar(modfreq).range(0, 1);
	freq = freq * LFNoise2.kr([2, 1/2, 1/3, 1/4, 1]).range(0.98, 1.01);
    carrier = Pulse.ar(freq: freq, mul: env * modulator);
	carrier = Mix.ar(carrier);
	carrier = LPF.ar(carrier, Line.kr(10000, 1000, att));
	Out.ar(0, Pan2.ar(carrier, pos));
}).add;

SynthDef("fm1", {arg freq = 440, modfreq = 5, modindex = 10, amp = 0.1, pos = 0, gate = 1, att = 0.01, rel = 0.3;
	var carrier, modulator, freqdev, env;
	// i = d/m, so d = m*i
	freqdev = modfreq * modindex;
	modulator = SinOsc.ar(freq: modfreq, mul: freqdev);
	carrier = SinOsc.ar(freq: freq + modulator);
	env = Env.asr(
		attackTime: att,
		sustainLevel: amp,
		releaseTime: rel
	).kr(doneAction: 2, gate: gate);
	carrier = Pan2.ar(in: carrier, pos: pos, level: env);
	Out.ar(0, carrier * 0.5);
}).add;

SynthDef("fm2", {arg freq = 440, modindex = 10, amp = 0.1, pos = 0, gate = 1, att = 0.01, rel = 0.3;
	var carrier, modulator, freqdev, env, modfreq;
	// i = d/m, so d = m*i
	modindex = Line.kr(modindex, 1, att);
	modfreq = freq / 2;
	freqdev = modfreq * modindex;
	modulator = SinOsc.ar(freq: modfreq, mul: freqdev);
	carrier = SinOsc.ar(freq: freq + modulator);
	env = Env.asr(
		attackTime: att,
		sustainLevel: amp,
		releaseTime: rel
	).kr(doneAction: 2, gate: gate);
	carrier = Pan2.ar(in: carrier, pos: pos, level: env);
	Out.ar(0, carrier * 0.5);
}).add;
)

//:
(
~a = Pbind(
    \instrument, "am1",
    \midinote, Pseq([50, 55, 60, 70, 75, 69], inf),
    \dur, Pseq([Pn(0.5, 5),    1.5], inf),
    \amp, Pwhite(0.15, 0.2),
    \att, 0.1,
    \rel, 3,
    \modfreq, Pseq([12, 9, 7, 5, 3], inf),
	\pos, 0
);


~b= Pbind(
	\instrument, "am2",
	\degree, Pseq([0, 2, 6], inf),
	\modfreq, Prand([10, 5, 10, 50, 130], inf),
	\amp, Pwhite(0.1, 0.9),
	\dur, 0.1,
	\att, 0.01,
	\rel, Pwhite(0.3, 0.9),
	\pos, Pseq(series(-1, -0.9, 1), inf)
);

~c = Pbind(
    \instrument, "am3",
    \midinote, Prand([72, 79, 77, 79, 82, 79, 87, 86, 84, 82, 84, 79], inf),
	\ctranspose, -12,
	\dur, Pseq([Pn(0.5, 5), Prand([1.5, 3])], inf),
    \amp, Pwhite(0.15, 0.5),
	\att, Pwhite(0.5, 1),
	\rel, Pwhite(1, 3.0),
    \modfreq, Pseq([7, 9, 10, 11], inf)
);



~d = Pbind(
    \instrument, "fm1",
    \dur, 0.2,
	\degree, Pseq([0, 4, 5, 6], 2),
	\ctranspose, [-4, 0, 3, 5, 9],
	\modfreq, Pwhite(10, 40),
    \modindex, 1, //
	\amp, Pseq([0.3, 0.2, 0.1, 0.05], inf),
	\att, 0.01,
	\rel, 0.1,
	\pos, Pwhite(-1, 1.0)
);


~e = Pbind(
    \instrument, "fm2",
	\dur, 0.5,
	\degree, Pseq([1, 3, 6, 7], 2),
	\ctranspose, [-1, 0, 5, 7, 9],
	\modfreq, Pwhite(10, 40),
    \modindex, 1, 
	\amp, Pseq([0.3, 0.2, 0.1, 0.05], inf),
	\att, 0.01,
	\rel, 0.1,
	\pos, Pwhite(-1, 1.0)
);


~f = Pbind(
    \instrument, "am1",
    \midinote, Pseq([71, 67, 63, 60, 55, 50], inf),
    \dur, Pseq([Pn(0.5, 5),    1.5], inf),
    \amp, Pwhite(0.15, 0.2),
    \att, 0.1,
    \rel, 3,
    \modfreq, Pseq([12, 9, 7, 5, 3], inf),
	\pos, 0
);

)
//:
~a.play;
~b.play;
~c.play;
~d.play;
~e.play;
~f.play;

//:
(

{

	~aplay = ~a.play;
	3.wait;
	~aplay.stop;
	1.wait;
	~aplay = ~a.play;
	6.wait;
	~cplay = ~c.play;
	4.wait;
	~aplay.stop;
	6.wait;
	~cplay.stop;
	~fplay = ~f.play;
	4.wait;
	~fplay.stop;
	~bplay = ~b.play;
	5.wait;
	~bplay.stop;
	1.wait;
	~fplay = ~f.play;
	4.wait;
	~fplay.stop;
	~aplay = ~a.play;
	3.wait;
	~aplay.stop;
	~fplay = ~f.play;
	1.wait;
	~fplay.stop;
	~aplay = ~a.play;
	6.wait;
	~cplay = ~c.play;
	4.wait;
	~aplay.stop;
	6.wait;
	~cplay.stop;
	~fplay = ~f.play;
	
	
	
	
	
	
    
	
	
	
}.fork
)