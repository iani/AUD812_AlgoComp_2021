/*
	From: http://sccode.org/1-5do#c942
*/

(

//This code is free to use/share/modify. I only ask that you credit the author: Eli Fieldsteel.
//It is shared with the permission of the author.

//A SuperCollider rendition of the orchestral intermezzo
//from Pietro Mascagni's 'Cavalleria rusticana'
//Eli Fieldsteel
//2020 May 27

s.freeAll;
ServerTree.removeAll;
s.newBusAllocators;
~faderBus = Bus.audio(s, 2);
~reverbBus = Bus.audio(s, 2);
s.waitForBoot({

	Buffer.freeAll;

	s.sync;

	b = 6.collect({Buffer.alloc(s, 8192)});

	s.sync;

	//wavetables based on spectral analysis of orchestral instruments
	//cello 1
	~wt0 = Signal.sineFill(
		4096,

		([
			-12, -3, -21, -18, -24,
			-15, -18, -21, -18, -24,
			-27, -33, -27, -30, -30,
			-30, -30, -40, -90, -33,
			-40, -30, -27, -40, -33
		].dbamp++
		(26..300).reciprocal.pow(1.8)) *
		((1!25) ++ ({exprand(1/4,4)}!275)),

		{rrand(0,2pi)}!300
	).asWavetable;
	b[0].loadCollection(~wt0);


	//cello 2
	~wt1 = Signal.sineFill(
		4096,
		([
			-3, -6, -18, -36, -9,
			-24, -24, -27, -24, -40,
			-24, -21, -36, -40, -33,
			-36, -40, -33, -39, -40
		].dbamp ++
		(21..90).reciprocal.pow(1.9)) *
		((1!20) ++ ({exprand(1/3,3)}!70)),

		{rrand(0,2pi)}!90
	).asWavetable;
	b[1].loadCollection(~wt1);

	//viola
	~wt2 = Signal.sineFill(
		4096,
		([
			-3, -9, -6, -9, -18,
			-9, -15, -12, -15, -18,
			-15, -40, -24, -21, -30,
			-33, -33, -36, -30, -36
		].dbamp ++
		(21..60).reciprocal.pow(1.9)) *
		((1!20) ++ ({exprand(1/3,3)}!40)),

		{rrand(0,2pi)}!60
	).asWavetable;
	b[2].loadCollection(~wt2);

	//violin
	~wt3 = Signal.sineFill(
		4096,
		([
			-3, -6, -15, -9, -15,
			-12, -12, -24, -30, -24,
			-33, -27, -33, -33, -36,
			-40, -36, -36, -40, -40
		].dbamp ++
		(21..40).reciprocal.pow(2)) *
		((1!20) ++ ({exprand(1/3,3)}!20)),

		{rrand(0,2pi)}!40
	).asWavetable;
	b[3].loadCollection(~wt3);

	//oboe
	~wt4 =Signal.sineFill(
		4096,
		([
			-15, -3, -34, -41, -31,
			-31, -41, -34, -41, -41,
			-37, -37
		].dbamp ++
		(13..20).reciprocal.pow(2.2)) *
		((1!12) ++ ({exprand(1/2,2)}!8)),

		{rrand(0,2pi)}!20
	).asWavetable;
	b[4].loadCollection(~wt4);

	//organ
	~wt5 =Signal.sineFill(
		4096,
		[
			-3, -24, -12, -21, -24,
			-21, -30, -30, -33, -33,
			-36, -39, -42, -45, -48
		].dbamp,
		{rrand(0,2pi)}!15
	).asWavetable;
	b[5].loadCollection(~wt5);

	s.sync;

	SynthDef.new(\strings, {
		arg buf=0, freq=200, phs=0, detune=0.12,
		vibHz=6, vibPhs=0, vibDepth=0.1, vibFadeIn=2,
		atk=0.2, sus=0.01, rel=2, c0=1, c1=(-1), gate=1,
		amp=0.2, lpf=20000, lsf=150, ldb=4,
		pan=0, out=0;
		var sig, vibEnv, vibHzRand, detuneSig, env;
		env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel],[c0,0,c1],1), gate, doneAction:2);
		sig = 12.collect({
			detuneSig = LFNoise1.kr(Rand(0.05,0.1)).bipolar(detune).midiratio;
			vibHzRand = LFNoise1.kr(Rand(0.15,0.3)).exprange(5/6,6/5);
			vibEnv = SinOsc.kr(vibHz * vibHzRand, vibPhs).bipolar(vibDepth);
			vibEnv = vibEnv * EnvGen.kr(Env.new([0,1],[vibFadeIn],[1]));
			vibEnv = vibEnv.midiratio;
			Osc.ar(
				buf,
				freq * detuneSig * vibEnv,
				Rand(0.0,1.0)
			);
		});
		sig = Splay.ar(sig) * env;
		sig = LPF.ar(sig, lpf);
		sig = BLowShelf.ar(sig, lsf, 1, ldb);
		sig = Balance2.ar(sig[0], sig[1], pan, amp);
		Out.ar(out, sig);
	}).add;

	SynthDef.new(\pizz, {
		arg buf=0, freq=200, phs=0, detune=0.05,
		vibHz=6, vibPhs=0, vibDepth=0.05, vibFadeIn=0.5,
		atk=0.01, rel=1, c0=1, c1=(-4),
		amp=0.2, lpf=20000, lsf=150, ldb=4,
		pan=0, out=0;
		var sig, vibEnv, vibHzRand, detuneSig, env;
		env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[c0,c1]), doneAction:2);
		sig = 6.collect({
			detuneSig = LFNoise1.kr(Rand(0.05,0.1)).bipolar(detune).midiratio;
			vibHzRand = LFNoise1.kr(Rand(0.15,0.3)).exprange(5/6,6/5);
			vibEnv = SinOsc.kr(vibHz * vibHzRand, vibPhs).bipolar(vibDepth);
			vibEnv = vibEnv * EnvGen.kr(Env.new([0,1],[vibFadeIn],[1]));
			vibEnv = vibEnv.midiratio;
			Osc.ar(
				buf,
				freq * detuneSig * vibEnv,
				Rand(0.0,1.0)
			);
		});
		sig = Splay.ar(sig) * env;
		sig = LPF.ar(sig, lpf);
		sig = BLowShelf.ar(sig, lsf, 1, ldb);
		sig = Balance2.ar(sig[0], sig[1], pan, amp);
		Out.ar(out, sig);
	}).add;

	SynthDef.new(\winds, {
		arg buf=0, freq=200, phs=0, detune=0.01,
		vibHz=2, vibPhs=0, vibDepth=0.03, vibFadeIn=1,
		atk=0.2, sus=0.01, rel=2, c0=1, c1=(-1), gate=1,
		amp=0.2, pan=0, out=0;
		var sig, vibEnv, vibHzRand, detuneSig, env;
		env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel],[c0,0,c1],1), gate, doneAction:2);
		sig = 4.collect({
			detuneSig = LFNoise1.kr(Rand(0.05,0.1)).bipolar(detune).midiratio;
			vibHzRand = LFNoise1.kr(Rand(0.15,0.3)).exprange(5/6,6/5);
			vibEnv = SinOsc.kr(vibHz * vibHzRand, vibPhs).bipolar(vibDepth);
			vibEnv = vibEnv * EnvGen.kr(Env.new([0,1],[vibFadeIn],[1]));
			vibEnv = vibEnv.midiratio;
			Osc.ar(
				buf,
				freq * detuneSig * vibEnv,
				Rand(0.0,1.0)
			);
		});
		sig = Splay.ar(sig) * env;
		sig = Balance2.ar(sig[0], sig[1], pan, amp);
		Out.ar(out, sig);
	}).add;

	//provides global level control via audio bus
	SynthDef.new(\fader, {
		arg db=(-12), in=0, out=0, outReverb=0, sendAmp=0.6;
		var sig;
		sig = In.ar(in, 2);
		sig = LPF.ar(sig, 8000);
		sig = sig * (db.varlag(1).dbamp);
		Out.ar(out, sig);
		Out.ar(outReverb, sig * sendAmp);
	}).add;

	SynthDef(\reverb, {
		arg in=0, out=0, dec=3.5, lpf=1200;
		var sig;
		sig = In.ar(in, 2);
		sig = DelayN.ar(sig, 0.025, 0.025);
		sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
		sig = Splay.ar(sig);
		sig = LPF.ar(sig, lpf);
		5.do{
			sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, dec);
		};
		sig = LPF.ar(sig, lpf);
		sig = LeakDC.ar(sig);
		Out.ar(out, sig);
	}).add;

	s.sync;

	~initTree = {
		s.bind({
			~mainGroup = Group.new;
			~faderGroup = Group.after(~mainGroup);
			~reverbGroup = Group.after(~faderGroup);
			~faderSynth = Synth(
				\fader, [
					\in, ~faderBus,
					\amp, -20.dbamp,
					\out, 0,
					\outReverb, ~reverbBus,
					\sendAmp, 0.4,
				],
				~faderGroup
			);
			~reverb = Synth(
				\reverb, [
					\in, ~reverbBus,
					\dec, 4,
					\lpf, 1200,
					\out, 0,
				],
				~reverbGroup
			);
		});
	};

	s.sync;

	ServerTree.add(~initTree);
	ServerTree.run;

	s.sync;

	~count = -1;
	t.stop;
	t = TempoClock.new(48/60).permanent_(true);

	//scheduled tempo changes
	t.schedAbs(27, {
		t.tempo_((48*0.975.pow(~count+1))/60);
		~count = ~count + 1;
		[1,1,1,1,nil].at(~count);
	});

	t.schedAbs(33, {~count = -1; t.tempo_(48/60); nil});

	t.schedAbs(51, {
		t.tempo_((48*0.975.pow(~count+1))/60);
		~count = ~count + 1;
		[1,1,1,1,nil].at(~count);
	});
	t.schedAbs(57, {~count = -1; t.tempo_(48/60); nil});

	t.schedAbs(92, {
		t.tempo_((48*1.035.pow(~count+1))/60);
		~count = ~count + 1;
		[1,1,1,nil].at(~count);
	});

	t.schedAbs(96, {~count = -1; t.tempo_(48/60); nil});

	t.schedAbs(126, {
		t.tempo_((48*0.97.pow(~count+1))/60);
		~count = ~count + 1;
		[1,1,1,1,1,1,1,1,nil].at(~count);
	});
	t.schedAbs(135, {~count = -1; t.tempo_(36/60); nil});

	~phrase1 = Ppar([

		//violin 1
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				1, 1, 1,
				1.5, 0.5, 0.5, 0.5,
				0.5, 0.5, 2,
				1, 2.5,
				0.5, 0.5, 0.5, 0.75, 0.25,
				2, 0.75, 0.25,
				1, 1, 0.2, 0.2, 0.2, 0.2, 0.2,
				1.5, 0.5, 0.5, 1,
				0.5, 0.5, 0.5, 0.5, 0.5,
				0.25, 0.25, 0.25, 0.25, 1.5, 0.5,
				2.5, 0.5,
			], 1),
			\buf, b[3].bufnum,
			\degree, Pseq([
				0, 2, 4,
				4, 3, 2, 1,
				5, 0, 2,
				1, 2,
				0, -1, -2, 5, 3.1,
				4, 3, -2,
				2, 1, 3, 4, 3, -2, 0,
				2, 1, 0, 5,
				4, 3.1, 2, 1, 0,
				0, -1, 1, -5, -1, -2,
				-3, \,
			], 1),
			\root, 5,
			\gtranspose, 12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.25,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -9,
			\pan, -0.5,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//violin 2 upper divisi
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				3,
				3,
				1, 1, 1,
				1, 2,
				2, 1,
				2, 1,
				2, 1,
				2, 1,
				2, 1,
				0.5, 0.5, 2,
				2.5, 0.5,
			], 1),
			\buf, b[2].bufnum,
			\degree, Pseq([
				4,
				5,
				5, 4, 5,
				6, 6,
				5, 5,
				4, 3,
				3, 3,
				3, 2,
				5, 5,
				4, 2, 3.1,
				1, \,
			], 1),
			\root, 5,
			\gtranspose, 0,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.25,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, -0.2,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//violin 2 lower divisi
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				3,
				3,
				1, 2,
				1, 2,
				2, 1,
				2, 1,
				2, 1,
				2, 1,
				2, 1,
				0.5, 0.5, 2,
				2.5, 0.5,
			], 1),
			\buf, b[2].bufnum,
			\degree, Pseq([
				2,
				0,
				0, 2,
				1, 2,
				2, 3.1,
				1, 0,
				-1, 0,
				-1, 0,
				1, 1,
				1, 0, 0,
				-1, \,
			], 1),
			\root, 5,
			\gtranspose, 0,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.25,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, -0.1,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//viola
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				3,
				3,
				1, 2,
				1, 2,
				2, 1,
				1, 1, 1,
				2, 1,
				2, 1,
				2, 1,
				0.5, 0.5, 2,
				2.5, 0.5,
			], 1),
			\buf, b[1].bufnum,
			\degree, Pseq([
				7,
				5,
				5, 7,
				6, 6,
				7, 7,
				7, 6, 5,
				6, 5,
				6, 7,
				7, 5,
				4, 4, 3.1,
				4, \,
			], 1),
			\root, 5,
			\gtranspose, -12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.3),
			\sus, 0.1,
			\rel, 0.25,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, 0.2,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//cello
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				1,1,1,
				2,0.5,0.5,
				1,1,1,
				1, 2,
				2, 1,
				2, 1,
				2, 1,
				1, 1, 1,
				2, 0.5, 0.5,
				0.5, 0.5, 2,
				2.5, 0.5,
			], 1),
			\buf, b[0].bufnum,
			\degree, Pseq([
				7, 6, 5,
				1, 2, 3,
				3.1, 4, 3.1,
				4, 4.1,
				5, 1,
				4, 1,
				4, 1,
				4, 4.1, 5,
				1, 2, 3.1,
				4, -2, 1,
				4, \,
			], 1),
			\root, 5,
			\gtranspose, -12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.4),
			\sus, 0.0,
			\rel, 0.25,
			\c0, -1,
			\c1, -2,
			\gate, 1,
			\db, -9,
			\pan, 0.5,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//two pizzicato notes at end of phrase
		Pbind(
			\instrument, \strings,
			\dur, Pseq([31, 1, 1], 1),
			\buf, b[5].bufnum,
			\degree, Pseq([\, [1,8], [-3,4]], 1),
			\root, 5,
			\gtranspose, -24,
			\phs, 0,
			\detune, 0.05,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.05,
			\vibFadeIn, 0.3,
			\atk, 0.01,
			\rel, 1,
			\c0, 1,
			\c1, -4,
			\db, -18,
			\ldb, 3,
			\pan, 0,
			\out, ~faderBus,
			\group, ~mainGroup,
		),

	], 1);

	~phrase2 = Ppar([

		//violin 1
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				1, 1, 1,
				3,
				1, 1, 1,
				3,
				1, 1, 1,
				0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
				0.5, 0.5, 1.5, 0.5,
				2.5, 0.5,

			], 1),
			\buf, b[3].bufnum,
			\degree, Pseq([
				-2,-1,0,
				-1,
				-2,-1,0,
				-1,
				-1,4,-1,
				-1,-2,3.1,2,1,-3,
				0,-5,-1,-2,
				-3, \,
			], 1),
			\root, 5,
			\gtranspose, 12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.9,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -9,
			\pan, -0.5,
			\out, ~faderBus.index,
		),

		//violin 2 full divisi
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				1, 1, 1,
				3,
				1, 1, 1,
				3,
				2, 1,
				1, 1, 1,
				1, 2,
				2.5, 0.5,
			], 1),
			\buf, b[3].bufnum,
			\degree, Pseq([
				3,4,5,
				4,
				3,4,5,
				4,
				[4,-1], [4,-1],
				[2, 2], [1,-2], 1,
				[0,-3], [0,-3.1],
				[-3,-1], \,
			], 1),
			\root, 5,
			\gtranspose, 0,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.9,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, -0.2,
			\out, ~faderBus.index,
		),

		//viola
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				1, 1, 1,
				3,
				1, 1, 1,
				3,
				2, 1,
				1, 1, 1,
				1, 2,
				2.5, 0.5,
			], 1),
			\buf, b[1].bufnum,
			\degree, Pseq([
				5, 4, 3,
				4,
				5, 4, 3,
				4,
				4, 4,
				4, 3.1, 4,
				2, 1,
				1, \,
			], 1),
			\root, 5,
			\gtranspose, -12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.3),
			\sus, 0.1,
			\rel, 0.25,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, 0.2,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//cello
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				1, 1, 1,
				3,
				1, 1, 1,
				3,
				2, 1,
				2, 1,
				1, 2,
				2.5, 0.5,
			], 1),
			\buf, b[0].bufnum,
			\degree, Pseq([
				3, 2, 1,
				2,
				3, 2, 1,
				2,
				1, 0.1,
				0, -1,
				-2, -6,
				-3, \,
			], 1),
			\root, 5,
			\gtranspose, -12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 1.1,
			\atk, (Pkey(\dur) * 0.3).max(0.4),
			\sus, 0.0,
			\rel, 0.25,
			\c0, -1,
			\c1, -2,
			\gate, 1,
			\db, -9,
			\pan, 0.5,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//oboe solo
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				3,
				0.5, 1, 0.5, 0.5, 0.5,
				3,
				0.5, 1, 0.5, 0.5, 0.5,
				12,
			], 1),
			\buf, b[4].bufnum,
			\degree, Pseq([
				\,
				\, 4, 3.1, 2, -1,
				\,
				\, 4, 3.1, 2, -1,
				\,
			], 1),
			\root, 5,
			\gtranspose, 12,
			\phs, 0,
			\detune, 0.08,
			\vibHz, 3,
			\vibPhs, 0,
			\vibDepth, 0.03,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.9,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.2,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -6,
			\pan, 0,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//two pizz notes at end of phrase
		Pbind(
			\instrument, \pizz,
			\dur, Pseq([22, 1, 1], 1),
			\buf, b[5].bufnum,
			\degree, Pseq([\, [1,8], [-3,4]], 1),
			\root, 5,
			\gtranspose, -24,
			\phs, 0,
			\detune, 0.05,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.05,
			\vibFadeIn, 0.3,
			\atk, 0.01,
			\rel, 1,
			\c0, 1,
			\c1, -4,
			\db, -18,
			\ldb, 4,
			\pan, 0,
			\out, ~faderBus,
			\group, ~mainGroup,
		)

	],1);

	~phrase3 = Ppar([

		//organ
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				Pseq([2, 1],12),
				1,1,1,
				1,1,1,
				2,1,

				1,1,1,
				1,1,1,
				2,1,
				2,1,

				1,1,1,
				1,1,1,
				2,1,
				2,1,

				2,1,
				2,1,
				2,1,
				3,3.5,2.5,
			], 1),
			\buf, b[5].bufnum,
			\degree, Pseq([

				[0,2,4,9], [-1,1,4,11],
				[-2,0,2,7], [-3,-1,2,9],
				[-4,-2,0,5], [-6,0,3,5,10],
				[-3,-1,3,6,9], [-3,-1,3,6,8],

				[-6,1,3,5,10], [-4,0,3,5],
				[-7,0,2,4,9], [-2,2,5,7],
				[-3,2,7,9], [-10,-3,3,6,8],
				[-7,0,2,4,7], [-5,0,4,7],

				[-4,0,3,5], [-6,0,3,5,10],
				[-3,-1,3,4,9], [-1,3,4,8],
				[-2,3,7,10], [-4,3,5,8],
				[-6,3,4,7], [-3,1,3,6],

				[-2,0,2,5], [-3,0,2,5], [-4,0,1,5],
				[-5,0,2,4], [-5,0,4,7], [-6,3,5,7],
				[-3,2,4,7], [-10,-3,3,4,6],

				Pseq([
					[-7,0,2,4,7], [-1,2,4,7], [-2,2,5,7],
					[-3,2,5,7], [-4,3,5,7], [-5,3,5,7],
					[-6,3,5,7], [-4,0,5,7],
					[-3,2,4,7], [-10,-3,3,4,6],
				],2),

				[-7,0,2,4,7], [-1,2,4,7],
				[-2,2,5,7], [-3,2,5,7],
				[-4,3,5,7], [-6,3,5,7],
				[-7,2,7,11], [0,2,4,7], \,



			], 1),
			\root, 5,
			\gtranspose, -12,
			\phs, 0,
			\detune, 0.04,
			\vibHz, Pexprand(0.5,2.0),
			\vibPhs, Pwhite(0,1.0),
			\vibDepth, 0.05,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.9,
			\atk, (Pkey(\dur) * 0.3).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -12,
			\lpf, 1500,
			\lsf, 200,
			\ldb, 3,
			\pan, 0,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//violin 1
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				2,1,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				2,1,
				1,1,1,
				2,1,
				3,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,Pseq([0.25],4),
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				3, 3.5, 2.5,
			], 1),
			\buf, b[3].bufnum,
			\degree, Pseq([
				2,4,
				0,2,
				-2,5,4,3,0,
				2,1,
				3,-2,
				2,4,0,
				2,1,
				0,
				5,5,4,3,0,
				2,1,
				3,3,2,1,-2,
				0,-1,
				0,1,2,3,4,5,6,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,-1,0,1,
				2,0,2,5,
				5,3,5,7,
				9,9,\,
			], 1),
			\root, 5,
			\gtranspose, 12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.99,
			\atk, (Pkey(\dur) * 0.5).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -9,
			\pan, -0.5,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//violin 2
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				2,1,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				2,1,
				1,1,1,
				2,1,
				3,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,Pseq([0.25],4),
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				3, 3.5, 2.5,
			], 1),
			\buf, b[2].bufnum,
			\degree, Pseq([
				2,4,
				0,2,
				-2,5,4,3,0,
				2,1,
				3,-2,
				2,4,0,
				2,1,
				0,
				5,5,4,3,0,
				2,1,
				3,3,2,1,-2,
				0,-1,
				0,1,2,3,4,5,6,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,-1,0,1,
				2,0,2,5,
				5,3,5,7,
				9,9,\,
			], 1),
			\root, 5,
			\gtranspose, 0,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.99,
			\atk, (Pkey(\dur) * 0.5).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, -0.2,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//viola
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				2,1,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				2,1,
				1,1,1,
				2,1,
				3,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,Pseq([0.25],4),
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				3, 3.5, 2.5,
			], 1),
			\buf, b[1].bufnum,
			\degree, Pseq([
				2,4,
				0,2,
				-2,5,4,3,0,
				2,1,
				3,-2,
				2,4,0,
				2,1,
				0,
				5,5,4,3,0,
				2,1,
				3,3,2,1,-2,
				0,-1,
				0,1,2,3,4,5,6,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,-1,0,1,
				2,0,2,5,
				5,3,5,7,
				9,9,\,
			], 1),
			\root, 5,
			\gtranspose, 0,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.99,
			\atk, (Pkey(\dur) * 0.5).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -15,
			\pan, 0.2,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),

		//cello
		Pbind(
			\instrument, \strings,
			\dur, Pseq([
				2,1,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				2,1,
				1,1,1,
				2,1,
				3,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,0.5,0.5,
				2,1,
				1,0.5,0.5,Pseq([0.25],4),
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1,1,1,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				1.5,0.5,0.5,0.5,
				3, 3.5, 2.5,
			], 1),
			\buf, b[0].bufnum,
			\degree, Pseq([
				2,4,
				0,2,
				-2,5,4,3,0,
				2,1,
				3,-2,
				2,4,0,
				2,1,
				0,
				5,5,4,3,0,
				2,1,
				3,3,2,1,-2,
				0,-1,
				0,1,2,3,4,5,6,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,7,7,7,
				7,7,7,7,
				7,7,6,5,
				2,4,-1,
				0,-1,0,1,
				2,0,2,5,
				5,3,5,7,
				9,9,\,
			], 1),
			\root, 5,
			\gtranspose, -12,
			\phs, 0,
			\detune, 0.13,
			\vibHz, 7,
			\vibPhs, 0,
			\vibDepth, 0.15,
			\vibFadeIn, Pkey(\dur) * 0.6,
			\sustain, Pkey(\dur) * 0.99,
			\atk, (Pkey(\dur) * 0.5).max(0.1),
			\sus, 0.1,
			\rel, 0.5,
			\c0, 0.5,
			\c1, -2,
			\gate, 1,
			\db, -8,
			\pan, 0.5,
			\out, ~faderBus.index,
			\group, ~mainGroup,
		),
	],1);

	//controls global orchestral crescendo and decrescendo
	~dynamics = Pbind(
		\type, \set,
		\id, ~faderSynth,
		\args, #[\db],
		\db, Pseq([

			//phrase 1
			0,0,0,
			0,0,0,
			0,0,1,
			3,2,0,

			Pseq([0],12),

			-1,-2,-3,
			-3,-4,-5,
			-6,-6,-6,

			//phrase 2
			Pseq([-5],12),

			-4,-3,-2,
			-2,-1,1,
			0,-2,-3
			-4,-4,-4,

			//phrase 3
			0,1,2,
			Pseq([3],18),
			1,0,0,

			Pseq([2],6),
			2,1,0,
			-1,-2,-3,
			-3,0,3,
			6,6,4,
			2,0,-3,
			-5,0,4,
			6,6,6,
			6,6,4,
			3,1,-1,
			-3,0,4,
			7,7,7,
			7,6,4,
			3,0,-2,
			-3,-3,-3,
			-4,-4,-5,
			-6,-7,-8,
			-9,-9,-10,
			-11,-12,-14,
			-15,-15,-15,
			-15,-15,-15,
			-15,-15,-15,
		]-18, 1),
		\dur, Pseq([1],123),
	);

	~fullPiece = Ppar([

		Pseq([
			~phrase1,
			~phrase2,
			~phrase3
		],1),

		~dynamics

	],1).play(t, quant:1);
});
)