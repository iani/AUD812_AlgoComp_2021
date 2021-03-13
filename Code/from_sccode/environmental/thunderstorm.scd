//: 26 Nov 2020 11:37
// From: https://sccode.org/1-29o
/*
«Thunderstorm» by Henk Lasschuit
on 06 Mar'12 12:52 in rainthunderwind

A thunderstorm, made with SuperCollider. There are three layers of sounds: rain, wind and thunder. There is a global envelope controlling the density of the raindrops and the thunder as well as the frequency of the wind. For the rain there are ticks of noise, but also a few drops falling on metal objects. I like that sound. For the wind there are two identical functions, one plays in the left channel and one plays right. Thunder is the most complicated of them all. It is filtered noise with a slow trigger for making a thunderclap and a fast trigger for the rumbling within a thunder. I added some FreeVerb to make it more spatial.

*/
//:Global sinusoidal envelope simulates passing of the storm
(
//Global sinusoidal envelope simulates passing ...
SynthDef (\global, {
	arg uitbus, duur;
	Out.kr(uitbus, EnvGen.kr(Env.sine(duur, 1), doneAction: 2))
}).send(s);
)

//Rain
//:metal sound
(
SynthDef (\regen, {
	arg inbus;
	var trig;
	trig=Dust.kr(0.3*In.kr(inbus, 1)); //not to frequent, controlled by global envelope
Out.ar(
	 	0,
	 	Pan2.ar(				// in, pos, level
	 		SinOsc.ar(
	 			TRand.kr(1000, 2000, trig), //every drop has its own frequency
	 			0, 					//fase
	 			0.7 + (0.5* SinOsc.kr(	//amplitude-modulation
	 						TRand.kr(1000, 2000, trig),
	 						1.5*pi,			//fase
	 						TRand.kr(0.0, 1.0, trig)//varying modulation
	 					))						//end of modulator
	 		),								//end of SinOsc
	 			TRand.kr(-1.0, 1.0, trig),//each drop has its own position in panorama
	 			0.1								//low level, to make room for thunder
	 	)									//end of Pan2
		*EnvGen.kr(
			Env.perc(
				0.01, 						//short attack
				TRand.kr(0.1, 1.0, trig), //each drop has its own eigen decay-time
				1, 							//normal level
				-8							//good curve
			), 								//end of Env
			trig							//start raindrop
		)									//end of EnvGen
	)										//end of Out
}).send(s);
)
//:Rain with white noise
(
SynthDef (\regen2, {
	arg inbus;
	var trig;
	trig=Dust.kr(20*In.kr(inbus, 1)); //many drops, controlled by global envelope
	Out.ar(
		0,
		Pan2.ar(
			LPF.ar(
				WhiteNoise.ar(0.1), 		//white noise with low level
				LFNoise1.kr(0.5, 200, 2000),//slightly varying sound
				1 								//normal level
			)*									//end of LPF
			EnvGen.kr(
				Env.perc(0.005, 0.005, 1, -8), //short attack and decay
				trig
			),									//end of EnvGen
			TRand.kr(-1.0, 1.0, trig),	//each drop has its own position in panorama
			1									//normal level
		) 										//end of Pan2
	);											//end of Out
}).send(s);
)
//:wind
(
SynthDef(\wind, {
	arg inbus;
	var w1, w2;								//two identical functions, one left, one right
	w1=RLPF.ar(
		WhiteNoise.ar(1), 					//normal level, out level comes later
		LFNoise1.kr(0.5, 1000, 1100)*In.kr(inbus, 1) + 20,//filter controlled by global envelope.
												//Beware of low cutoff when using RLPF
		LFNoise1.kr(0.4, 0.45, 0.55),  // 0.55 to 1 varying reciprocal Q
		0.1*In.kr(inbus, 1)			//low level, controlled by global envelope
	);
	w2=RLPF.ar(
		WhiteNoise.ar(1),
		LFNoise1.kr(0.5, 1000, 1100)*In.kr(inbus, 1) + 20,
		LFNoise1.kr(0.4, 0.45, 0.55),
		0.1*In.kr(inbus, 1)
	);
	Out.ar(0,[w1, w2] )
}).send(s);
)

//:Thunder. Obviously filtered noise with two triggers: 1 for rumbling en 1 to start a thunderclap
(
SynthDef (\donder, {
	arg inbus;
	var trig1, trig2;
	trig1=Dust.kr(0.05	* In.kr(inbus, 1));//slow trigger for each thunder, controlled by global envelope
trig2=Dust.kr(15);						//fast trigger for rumbling
	Out.ar(0,
		FreeVerb.ar(
			Pan2.ar(
				RLPF.ar(						//filter, in, freq, rq, mul, add
					WhiteNoise.ar(1),		//white noise is the basis
					1500 *						//maximum frequency
					EnvGen.kr(				//how one thunder goes
						Env.perc(	0.05, 16, 1, -1),//attack, release, peak, curve
						trig1					//slow trigger
					)							//end of EnvGen for frequency
					* In.kr(inbus, 1) + 20,// bad things happen when frequency = 0
					0.55,						// reciprocal Q
					EnvGen.kr(				//rumbling, controls amplitude
						Env.perc(0.01, 0.5, 2, -1),
						trig2					//fast trigger
					)							// end of for amplitude
				),								//end of LPF
				LFNoise1.kr(0.1)			//freq
			),									//end of Pan2
			0.5,								//mix
			0.75,								//room
			0.5									//damp
		)										//einde FreeVerb
	)
}).send(s)
)

//:Global controlbus
b=Bus.control(s, 1);
g=Synth(\global, [\uitbus, b, \duur: 300]); //300 is number of seconds. Change this if you like
//:Here comes the rain
r=Synth.after(g, \regen, [\inbus, b]);
q=Synth.after(g, \regen2, [\inbus, b]);
//:here comes the wind
w=Synth.after(g, \wind, [\inbus, b]);
//:thunder
d=Synth.after(g, \donder, [\inbus, b]);

//:
d.free;
r.free;
q.free;