

(

thisProcess.interpreter.executeFile("/Users/nikos/Desktop/Nikolaos_Kanelakis_Microloop(SONARTS20-21) /Dictionary.scd"); // Dictionary for loading sound files into Buffers.

//==========
//SynthDefs
//==========


SynthDef.new(\sine, {
	arg freq=80, atk=0.05, rel=0.3, amp=1,pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar (sig, pan, amp);
	sig = sig * env;
	Out.ar (0, sig);
}).add;

SynthDef.new(\pulse, {
	arg freq=80, atk=0.05, rel=0.3, amp=1,pan=0;
	var sig, env;
	sig = Pulse.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar (sig, pan, amp);
	sig = sig * env;
	Out.ar (0, sig);
}).add;

SynthDef.new(\sub, {
	arg freq=100, atk=0.05, rel=0.2, amp=1,pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar (sig, pan, amp);
	sig = sig * env;
	Out.ar (0, sig);
}).add;

SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig *amp;
	Out.ar(0, sig);
}).add;

SynthDef(\subkick, {arg out = 0, amp = 0.3, sinfreq = 80, glissf = 0.1, att = 0.01, rel = 0.20, pan = 0;
	var env, snd, ramp;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;




//================
//    Pdefs
//================

~subkick =
Pdef(
	\subkick,
	Pbind(
		\instrument, \subkick,
		\dur, Pseq([1/16],inf),
		\stretch, 60/128 * 4,
		\rate, 1,
		\amp, Pseq([0.5, Pexprand(0.1,0.3,7)],inf),
	);
).quant_(1.875);

~rhythmclick =
Pdef(
	\rhythmclick,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16],inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\wood]++d[\plastic]++d[\ceramic], inf),
		\rate, 11,
		\amp, Pexprand(0.05,0.2, inf),
	);
).quant_(1.875);


~tonalihits =
Pdef(
	\tonalhits,
	Pbind(
		\instrument, \bufplay,
		\dur, Pxrand([1/4,1/16,1/2],inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\tonal], inf),
		\rate, Pwrand([0.5,1.8],[0.25,0.75],inf),
		\amp, Pexprand(0.05,0.3,inf),
	);
).quant_(1.875);


~beat1_16 =
Pdef(
	\beat1_16,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16],inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\kick]++d[\hihat], inf),
		\rate, 1,
		\amp, Pexprand(0.1,0.5,inf),
	);
).quant_(1.875);

~kick1_16 =
Pdef(
	\kick1_16,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16],inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\mainkick], inf),
		\rate, 0.5,
		\amp, Pexprand(0.03,0.6,inf),
	);
).quant_(1.875);

~beatrandom =
Pdef(
	\beatrandom,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16],inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\kick]++d[\hihat]++d[\wood], inf),
		\rate,Pexprand(0.9,2,inf),
		\amp, Pexprand(0.05,0.2,inf),
	);
).quant_(1.875);

~beat1_8 =
Pdef(
	\beat1_8,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/8],inf),
		\stretch, 60/128 * 4,
		\buf, Pseq(
			[
				Prand(d[\kick], 1),
				Prand(d[\kick]++d[\hihat], 3),
				Prand(d[\kick], 1),
				Prand(d[\kick]++d[\hihat], 3),
				Prand(d[\kick], 1),
				Prand(d[\kick]++d[\hihat], 3),
				Prand(d[\kick], 1),
			],inf
		),
		\rate, 1,
		\amp, Pseq([0.3, Pexprand(0.005,0.05,3)], inf),
	);
).quant_(1.875);


~snare =
Pdef(
	\snare,
	Pbind(
		\instrument, \bufplay,
		\dur, 0.5,
		\stretch, 60/128 * 4,
		\buf, Prand(d[\snare], inf),
		\rate, 0.7,
		\amp, Pseq([0,0.4,0,0.4],inf),
	);
).quant_(1.875);


~tampouraki=
Pdef(
	\tampouraki,
	Pbind(
		\instrument, \bufplay,
		\dur, 0.6,
		\stretch, 60/128 * 4,
		\buf, Prand(d[\tampouraki], inf),
		\rate, Prand([0.1,1],inf),
		\amp, 0.8,
	);
).quant_(1.875);


~water =
Pdef(
	\water,
	Pbind(
		\instrument, \bufplay,
		\dur, 0.6,
		\stretch, 60/128 * 4,
		\buf, Prand(d[\water], inf),
		\rate, Prand([0.1,0.7],inf),
		\amp, 0.1,
		\out, 1,
	);
).quant_(1.875);


~long =
Pdef(
	\long,
	Pbind(
		\instrument, \bufplay,
		\dur, 0.6,
		\stretch, 60/128 * 4,
		\buf, Prand(d[\long], inf),
		\rate, Prand([0.5,1],inf),
		\amp, 0.01,
	);
).quant_(1.875);


~kouzina1=
Pdef(
	\kouzina1,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/12], inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\kitchenut], inf),
		\rate, Prand([1,2],inf),
		\amp, Pexprand(0.1,0.4,inf),
		\pan, Pwhite (-0.9, 0.9, inf),
	);
).quant_(1.875);


~kouzina2=
Pdef(
	\kouzina2,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/4], inf),
		\stretch, 60/128 * 4,
		\buf, Prand(d[\kitchenap], inf),
		\rate, Prand([0.7,2],inf),
		\amp, Pexprand(0.1,0.3,inf),
		\pan, Pwhite (-0.9, 0.9, inf),
	);
).quant_(1.875);

~sinepat =
Pdef (
	\sinepat,
	Pbind (
		\type, \note,
		\instrument, \sine,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\note, Pxrand([12,5,9,4,12],inf),
		\atk, 0.001,
		\rel, Pwrand([0.1, 1],[0.9,0.1],inf),
		\amp, Pexprand(0.1,0.4,inf),
		\pan, Pwhite (-0.8, 0.2, inf),
	);
).quant_(1.875);

~sinepatB =
Pdef (
	\sinepatB,
	Pbind (
		\type, \note,
		\instrument, \sine,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\note, Pxrand([8,4,5,7],inf),
		\atk, 0.01,
		\rel, Pwrand([0.1, 1],[0.9,0.1],inf),
		\amp, 0.2,
		\pan, Pwhite (-0.8, 0.2, inf),
	);
).quant_(1.875);

~sinepat_octdown =
Pdef (
	\sinepat_octdown,
	Pbind (
		\type, \note,
		\instrument, \sine,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\note, Pxrand([0,-7,-3,-16,0],inf),
		\atk, 0.01,
		\rel, Pexprand(0.1, 0.4,inf),
		\amp, Pexprand(0.1,0.2,inf),
		\pan, Pwhite (-0.8, 0.2, inf),
	);
).quant_(1.875);

~pulsepat_rel = PatternProxy(Pexprand(0.02, 0.5,inf));
~pulsepat_atk = PatternProxy(0.005);
~pulsepat =
Pdef (
	\pulsepat,
	Pbind (
		\type, \note,
		\instrument, \pulse,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\note, Pxrand([12,5,9,4,12],inf),
		\atk, ~pulsepat_atk,
		\rel, ~pulsepat_rel,
		\amp, Pexprand(0.05,0.2,inf),
		\pan, Pwhite (-0.8, 0.8, inf),
	);
).quant_(1.875);

~sub =
Pdef (
	\sub,
	Pbind (
		\instrument, \sub,
	    \dur, Pseq([1/2], inf),
		\stretch, 1.875,
		\atk, 2,
	    \rel, 0.05,
		\note, -28,
		\amp, 0.3,
	);
).quant_(1.875);

~subB =
Pdef (
	\subB,
	Pbind (
		\instrument, \sub,
	    \dur, Pseq([1/2], inf),
		\stretch, 1.875,
		\atk, 2,
	    \rel, 0.05,
		\note, -23,
		\amp, 0.3,
	);
).quant_(1.875);
)



thisProcess.interpreter.executeFile("/Users/nikos/Desktop/Nikolaos_Kanelakis_Microloop(SONARTS20-21) /Score.scd");

s.meter;