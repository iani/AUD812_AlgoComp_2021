/* 22 Feb 2021 11:23
	From: https://raw.githubusercontent.com/vangelisgiaz/vangelis-giazi/main/%CE%B5%CF%81%CE%B3%CE%B1%CF%83%CE%B9%CE%B1%205.scd

Improvements needed
*/

(
s.boot;
v = s.volume;
v.volume = 6; // IZ: Volume does not seem to work

{var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig9, sig10, sig11, sig12, sig13, sig14;

	sig1 = {RLPF.ar(SinOsc.ar([100]), LFNoise1.ar([8, 9]).range(0, 100), 0.3)*0.1*Env.linen(8,30,30,1,1).kr( doneAction: 2)};

	sig2 = {SinOsc.ar(LFNoise0.kr(10).range(3000.6000))*0.2*Env.linen(5,25,10,0.2,1).kr( doneAction: 2)};

	sig3 = {RLPF.ar(WhiteNoise.ar(2), Saw.ar([4,5]).range(500, 4000), 0.2)*0.4*Env.linen(11,30,30,0.009,5).kr( doneAction: 2)};

	sig4 = {Gendy1.ar(0, 1, 0.2, 1.0, 100, 100, 0.3, 0.05, 5)*0.06*Env.linen(7,65,8,1,1).kr( doneAction: 2)!2};

	sig5 = {SinOsc.ar([600, 635]) * SinOsc.kr(2).max(0) * 0.1*Env.linen(10,5,10,1,1).kr( doneAction: 2) };

	sig6 =
	{x = RLPF.ar(SinOsc.ar(SinOsc.ar([0.020, 0.019]).range(3, 10)) * SyncSaw.ar(SinOsc.ar(0.01).range(1, 100),   SinOsc.ar(0.017).range(300,                       1000)), Line.ar(60, 10000, 60*5));
		x = GVerb.ar(x + CombL.ar(x, 10, 0.2, 10)*0.2);
		EnvGen.ar(Env.linen(0.01, 60*5, 20), doneAction:2) * x * 0.04*Env.linen(2,40,30,1,1).kr( doneAction: 2)!2};

	sig7 =

	{var noise = { WhiteNoise.ar(0.04 + LFNoise1.kr(0.3, 0.03)) };
		var motion = { LFNoise1.kr(0.2).exprange(100, 2000) };
		var hps = { HPF.ar(noise.value, 50) };
		var wave = { LPF.ar(hps.value, motion.value).tanh };
		var sig = wave!2;
		sig = Splay.ar(sig, 0.6).tanh;
		sig = sig * Line.kr(0, 1, 10);
		LeakDC.ar(sig)*1*Env.linen(1,112,8,1,1).kr( doneAction: 2);
	};


	~sig8 = Pbind(\dur, Prand([0.179,0.59,0.234,0.413,0.005,0.71,0.002,0.12,0.009],inf), \freq, Pbrown(0.3963, 1.543, 0.32, inf).linexp(0, 1, 1032.76,2046.46, 3724.647), \amp, Env.linen(15,15,15,0.03,1));

	sig9 = {DelayL.ar(SoundIn.ar(0,2)*0.5, 3,Saw.kr([10,25]) +  SinOsc.ar( LFNoise2.kr([2,7]),0,SinOsc.kr([3.5,2.9])))*0.4*Env.linen(7,9,8,1,1).kr( doneAction: 2)};



	sig10 =
	{RLPF.ar(LFTri.ar(Demand.kr(Impulse.kr([10, 5.1]), 0,Dser((200,300..900).scramble, inf)), 0, 0.2),LFNoise0.kr([0.2,0.21], 300, 400), 0.5, 0.1*Env.linen(4,62,4,1,1).kr( doneAction: 2))};


	sig11 =

	{var env;
		env = Env.linen(5,9,8,0.5,1);
		Out.ar(0,
			\amp.kr(0.3) *
			EnvGen.kr(env, \gate.kr(1), doneAction: 2) *
			Pan2.ar(
				SinOsc.ar(
					Resonz.ar(
						StandardL.ar(
							SampleRate.ir/50, 1),2000,0.1)*4000)
				, \pos.kr(0), \level.kr(1)))
	};


	sig12 =
	{ | bus = 50 |
		Mix.fill(8, {
			var fb, env, fq, osc;
			fb = (LFSaw.ar(
				Latch.ar(
					WhiteNoise.ar(0.5).abs
					+ 0.5,
					InFeedback.ar(bus,1)),1)+0.999)/2;
			Out.ar(bus, fb);
			env = 1-fb;
			fq = Latch.ar(WhiteNoise.ar(
				\noise.kr(1000))
				+ \noisep.kr(6000), fb);
			osc = SinOsc.ar(SinOsc.ar(fq*5/3,0,env**2*10000,fq),0,LPF.ar(env,100));
			Out.ar(0, \amp.kr(1)*Pan2.ar(osc,Latch.ar(WhiteNoise.ar(1),fb),0.01*Env.linen(10,25,15,0.15,1).kr( doneAction: 2)))})
	};



	sig13 = {Saw.ar(LFNoise0.kr(12).range(3000.6000),)*0.1*Env.linen(6,35,8,0.8,1).kr( doneAction: 2)};

	sig14 =
	{var alpha,gamma;
		alpha= LFNoise2;
		gamma= {[rrand(30,50),rrand(50,70),rrand(50,70),rrand(70,100)].choose.midicps*alpha.kr(1,0.01,1)}!24;
		Pan2.ar(LeakDC.ar(Normalizer.ar(
			BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(BPeakEQ.ar(FreeVerb.ar(
				Splay.ar(RLPF.ar(LFSaw.ar(gamma)/4,gamma*LFCub.kr(rrand(0.01,0.1),0,2,3),alpha.kr(1/8,0.6,0.7)))
				,0.1,0.1,0.1)
				,100,6.0,6),1000,6.0,0),5000,6.0,0),10000,6.0,6)
			,(0.8/0.999)*1,0.1)),0)*Env.linen(3,4,1.8,0.015,1).kr( doneAction: 2)
	};



	~sig15 = Pbind(\dur, Prand([0.01,0.05,0.078,0.04],inf), \freq, Pbrown(0, 0.5, 0.1, inf).linexp(0, 1, 200,350), \amp,Env.linen(12,15,20,0.05,1));



	0.wait; // IZ: Insert postln messages to help track progress of piece
	sig3.play;
	7.wait;
	sig1.play;
	7.wait;
	{Pan2.ar(in: sig2, pos: SinOsc.kr(0.25), level: 0.4)}.play;
	6.wait;
	sig6.play;
	8.wait;
	sig5.play;
	7.wait;
	~x = ~sig15.play;
	9.wait;
	~y = ~sig8.play;
	14.wait;
	sig5.play;
	1.wait;
	sig7.play;
	32.wait;
	//2o meros
	~x.stop;
	~y.stop;
	sig4.play;
	8.wait;
	sig10.play;
	8.wait;
	sig12.play;
	12.wait;
	sig11.play;
	5.wait;
	{Pan2.ar(in: sig13, pos: SinOsc.kr(0.8), level: 0.4)*0.35}.play;
	2.wait;
	{RLPF.ar(WhiteNoise.ar(2), Saw.ar([4,5]).range(500, 4000), 0.2)*0.3*Env.linen(11,13,15,0.009,5).kr( doneAction: 2)}.play;
	{SinOsc.ar([600, 635]) * SinOsc.kr(2).max(0) * 0.1*Env.linen(10,13,10,0.7,1).kr( doneAction: 2) }.play;
	10.wait;
	{SinOsc.ar(Dust.kr(100).range(3000.6000))*0.5*Env.linen(5,12,10,0.011,1).kr( doneAction: 2)!2}.play;
	33.5.wait;
	sig14.play;
	8.wait;
	{Pan2.ar(in: {Saw.ar(LFNoise0.kr(15).range(3000.6000),)*0.1*Env.linen(0,1.6,0,0.5,1).kr( doneAction: 2)};, pos: SinOsc.kr(0.8), level: 0.4)*0.4}.play;
	3.wait;
	v.volume = 0;
	Server.hardFreeAll;




}.fork;


)


