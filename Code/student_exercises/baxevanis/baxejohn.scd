
s.boot;
//:
(

{ var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig1 = {SinOsc.ar(LFNoise0.kr(8).range(5000.10000))*0.4*Env.linen(0,40,7,0.2,1).kr( doneAction: 2)
	};

	sig2 = {RLPF.ar(SinOsc.ar([80]), LFNoise1.kr([12, 20]).range(40, 100)*0.7)*Env.linen(3,50,20,0.4,0.7).kr( doneAction: 2)};

	sig3 = {SinOsc.ar(LFTri.ar(Demand.kr(Impulse.kr([20, 3.2]), 0,Dser((400,700..1200).scramble, inf)), 0, 0.2),LFNoise0.kr([0.6,4.30], 300, 400), 50, 0.1*Env.linen(4,62,4,1,1).kr( doneAction: 2))};

	sig4 = {Gendy1.ar(4, 8, 0.2, 1.0, 400, 5000, 0.3, 0.05, 5)*0.06*Env.linen(7,65,8,1,1).kr( doneAction: 2)!2};

	sig5 = {Gendy1.ar(2, 4, 0.2, 1.0, 100, 10000, 0.4, 0.05, 2)*0.06*Env.linen(7,65,8,1,1).kr( doneAction: 2)!2};

	sig6 = {RLPF.ar(SinOsc.ar([80]), LFNoise1.kr([12, 20]).range(40, 100)*0.8)*Env.linen(3,100,20,0.4,0.7).kr( doneAction: 2)};

	sig7 = {FreeVerb.ar(sig6*SinOsc(2), 0.9, 0.4, 0.2)*Env.linen(0,2,8,0.4,1).kr( doneAction: 2)};

	sig8 = {FreeVerb.ar(sig1, 0.3, 0.5, 0.1)*Env.linen(0,25,7,0.2,1).kr( doneAction: 2)};

	~p1 = Pbind(\dur, Prand([0.01,0.001,0.028,0.00337],10), \freq, Pbrown(5, 0.45, 0.78, inf).linexp(0, 1, 200,8000), \amp,Env.linen(2,5,20,0.05,1));

	~p2 = Pbind(\dur, Prand([0.01,0.001,0.028,0.00337],7), \freq, Pbrown(6, 0.05, 0.08, inf).linexp(0, 3, 2000,10000), \amp,Env.linen(6,25,20,0.05,1));

	// time arangment
	0.wait;
	sig2.play;
	sig3.play;
	10.wait;
	sig4.play;
	10.wait;
	{Pan2.ar(in: sig1, pos: SinOsc.kr(0.2), level: 0.6)}.play;
	9.wait;
	~z = ~p1.play;
	sig6.play;
	10.wait;
	sig5.play;
	7.wait;
	~x = ~p2.play;
	{Pan2.ar(in: sig6, pos: SinOsc.kr(0.6), level: 0.7)}.play;
	20.wait;
	~x.stop;
	~z.stop;
	10.wait;
	{Pan2.ar(in: sig8, pos: SinOsc.kr(0.5), level: 0.7)}.play;
	sig7.play;
	Server.hardFreeAll;
}.fork

)