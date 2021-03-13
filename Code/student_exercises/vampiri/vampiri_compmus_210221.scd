/*
wind whirles
https://sccode.org/1-4mJ
*/

(
a = fork {
	Ndef(\ttwnd).play;//(d,2,addAction:\addToHead);
	loop {
		var seed = thisThread.randSeed = 100000000.rand.debug('seed');
		Ndef(\ttwnd, {
			var freq = [20, 1500];
			Splay.ar(
				{
					var bands = 2.rrand(1);
					var sig = { [BPF,RLPF,RHPF].choose.ar(
						LFNoise2.ar(freq[0].rrand(freq[1]), LFNoise2.kr(0.1.exprand(1))),
						Array.rand(bands, freq[0], freq[1]),
						Array.rand(bands, 0.2, 1.8)
					).mean } ! 2;
					Rotate2.ar(sig[0], sig[1], LFSaw.kr(0.1.exprand(1)));
				} ! 4.rrand(6).debug('source'),
                                0.5.rrand(1)
			);
		}).fadeTime_(1.rrand(4.0));
		1.0.rrand(2).debug('wait(bts)').wait;
	}
}
)
Ndef(\ttwnd).stop;
a.stop;

/*
«alone in the storm» by grirgz
https://sccode.org/1-1WS
*/

(
b = Ndef(\alone, { arg amp=0.5;
        var source, local, lfo;

        lfo = LFNoise1.kr(0.32).abs*50+[70,0.01];
        source = Decay.ar(Impulse.ar(lfo), 0.1) * WhiteNoise.ar(0.2);
        source = source * [LFNoise1.ar(0.17,0.4,1.1), LFNoise1.ar(0.57,1,1)];
        source = source;

        local = LocalIn.ar(2) + source;

        local = LPF.ar(local, 400 + LFNoise1.kr(0.1,300,100)) * 1.5;
        local = HPF.ar(local, 100 + LFNoise1.kr(0.15,050,050)) * 1.0;
        local = DelayN.ar(local, 0.2, 0.1);

        local = Limiter.ar(local.reverse,0.5);
        LocalOut.ar(local * 0.6);
        local = [local, Decay.ar(Impulse.ar(LFNoise1.kr(2.12).exprange(2,400)), 0.2 + LFNoise1.kr(0.11,0.1)) * local];
        local = FreqShift.ar(local, LFNoise1.kr(LFNoise1.kr(0.21).exprange(0.1,5)).exprange(0.1,500));
        local = HPF.ar(local, LFNoise1.kr(0.4).range(50,170), LFNoise1.kr(0.1).range(0.1,0.7));

        Splay.ar(local, LFNoise1.kr(0.21).range(0,1)) * amp;
}).play;
)

(
fork {

a = fork {
	Ndef(\ttwnd).play;//(d,2,addAction:\addToHead);
	loop {
		var seed = thisThread.randSeed = 100000000.rand.debug('seed');
		Ndef(\ttwnd, {
			var freq = [20, 1500];
			Splay.ar(
				{
					var bands = 2.rrand(1);
					var sig = { [BPF,RLPF,RHPF].choose.ar(
						LFNoise2.ar(freq[0].rrand(freq[1]), LFNoise2.kr(0.1.exprand(1))),
						Array.rand(bands, freq[0], freq[1]),
						Array.rand(bands, 0.2, 1.8)
					).mean } ! 2;
					Rotate2.ar(sig[0], sig[1], LFSaw.kr(0.1.exprand(1)));
				} ! 4.rrand(6).debug('source'),
                                0.5.rrand(1)
			);
		}).fadeTime_(1.rrand(4.0));
		1.0.rrand(2).debug('wait(bts)').wait;
	}
};
10.wait;
Ndef(\ttwnd).stop;
a.stop;
20.wait;

}
)


/*
«esoteric tweet»
https://sccode.org/1-D
*/

c = fork{loop{h=[1,3,6,9,8,7,6,5,4].choose*(2**(1..9).choose);play{Splay.ar({SinOsc.ar(exprand(h,h+(h/30)),0,0.1)}!30)*LFGauss.ar(9,1/3,0,0,2)};2.wait}};


/*
«Paulstretch for SuperCollider» by jpdrecourt
https://sccode.org/1-5d6
*/

(
SynthDef(\paulstretchMono, { |out = 0, bufnum, envBufnum, pan = 0, stretch = 50, window = 0.25, amp = 1|
	// Paulstretch for SuperCollider
	// Based on the Paul's Extreme Sound Stretch algorithm by Nasca Octavian PAUL
	// https://github.com/paulnasca/paulstretch_python/blob/master/paulstretch_steps.png
	//
	// By Jean-Philippe Drecourt
	// http://drecourt.com
	// April 2020
	//
	// Arguments:
	// out: output bus (stereo output)
	// bufnum: the sound buffer. Must be Mono. (Use 2 instances with Buffer.readChannel for stereo)
	// envBufnum: The grain envelope buffer created as follows:
	//// envBuf = Buffer.alloc(s, s.sampleRate, 1);
	//// envSignal = Signal.newClear(s.sampleRate).waveFill({|x| (1 - x.pow(2)).pow(1.25)}, -1.0, 1.0);
	//// envBuf.loadCollection(envSignal);
	// pan: Equal power panning, useful for stereo use.
	// stretch: stretch factor (modulatable)
	// window: the suggested grain size, will be resized to closest fft window size
	// amp: amplification
	var trigPeriod, sig, chain, trig, pos, fftSize;
	// Calculating fft buffer size according to suggested window size
	fftSize = 2**floor(log2(window*SampleRate.ir));
	// Grain parameters
	// The grain is the exact length of the FFT window
	trigPeriod = fftSize/SampleRate.ir;
	trig = Impulse.ar(1/trigPeriod);
	pos = Demand.ar(trig, 0, demandUGens: Dseries(0, trigPeriod/stretch));
	// Extraction of 2 consecutive grains
	// Both grains need to be treated together for superposition afterwards
	sig = [GrainBuf.ar(1, trig, trigPeriod, bufnum, 1, pos, envbufnum: envBufnum),
		GrainBuf.ar(1, trig, trigPeriod, bufnum, 1, pos + (trigPeriod/(2*stretch)), envbufnum: envBufnum)]*amp;
	// FFT magic
	sig = sig.collect({ |item, i|
		chain = FFT(LocalBuf(fftSize), item, hop: 1.0, wintype: -1);
		// PV_Diffuser is only active if its trigger is 1
		// And it needs to be reset for each grain to get the smooth envelope
		chain = PV_Diffuser(chain, 1 - trig);
		item = IFFT(chain, wintype: -1);
	});
	// Reapply the grain envelope because the FFT phase randomization removes it
	sig = sig*PlayBuf.ar(1, envBufnum, 1/(trigPeriod), loop:1);
	// Delay second grain by half a grain length for superposition
	sig[1] = DelayC.ar(sig[1], trigPeriod/2, trigPeriod/2);
	// Panned output
	Out.ar(out, Pan2.ar(Mix.new(sig), pan));
}).add;
)

(
{
	var envBuf, envSignal, buffer;
	buffer = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
	// The grain envelope
	envBuf = Buffer.alloc(s, s.sampleRate, 1);
	envSignal = Signal.newClear(s.sampleRate).waveFill({|x| (1 - x.pow(2)).pow(1.25)}, -1.0, 1.0);
	envBuf.loadCollection(envSignal);
	s.sync();
	// Runs indefinitely
	d = Synth(\paulstretchMono, [\bufnum, buffer.bufnum, \envBufnum, envBuf.bufnum]);
}.fork;
)
d.free;

b.stop;


/*
«Re: Silly Voice» by wondersluyter
on 11 Dec'13 04:44 in formant synthesis, gregorian chant
https://sccode.org/1-4Vq
*/

(
// SynthDef
SynthDef("Choir", { arg
	freq = 220,
	amp = 0.5,
	vibratoSpeed = 6,
	vibratoDepth = 4,
	vowel = 0,
	att = 0.01,
	rel = 0.1,
	lag = 1,
	gate = 1;

	var in, vibrato, env, va, ve, vi, vo, vu, snd, temp_freq, temp_lag, temp_vowel;

  env = EnvGen.kr(Env.asr(att, 1, rel), gate, doneAction: 2);

  snd = DC.ar(0) ! 2;

  5.do { |i|
    vibrato = SinOsc.kr(vibratoSpeed + LFNoise1.kr(1).range(-1, 1), mul: vibratoDepth * LFNoise1.kr(1).range(0.5, 1));

    temp_freq = DelayC.kr(freq, 0.2, LFNoise1.kr(1).range(0, 0.2)) * LFNoise1.kr(0.5).range(0.98, 1.02);
    temp_lag = lag * LFNoise1.kr(1).range(0.5, 1);
    temp_vowel = DelayC.kr(vowel, 0.2, LFNoise1.kr(1).range(0, 0.2));

    in = VarSaw.ar(Lag.kr(temp_freq, temp_lag) + vibrato, width: LFNoise1.kr(1).range(0.05, 0.2)) * LFNoise1.kr(1).range(0.5, 1);


    va = BBandPass.ar(
      in: in,
      freq: [ 600, 1040, 2250, 2450, 2750 ],
      bw: [ 0.1, 0.067307692307692, 0.048888888888889, 0.048979591836735, 0.047272727272727 ],
      mul: [ 1, 0.44668359215096, 0.35481338923358, 0.35481338923358, 0.1 ]);

    ve = BBandPass.ar(
      in: in,
      freq: [ 400, 1620, 2400, 2800, 3100 ] ,
      bw: [ 0.1, 0.049382716049383, 0.041666666666667, 0.042857142857143, 0.038709677419355 ],
      mul: [ 1, 0.25118864315096, 0.35481338923358, 0.25118864315096, 0.12589254117942 ]);

    vi = BBandPass.ar(
      in: in,
      freq: [ 250, 1750, 2600, 3050, 3340 ] ,
      bw: [ 0.24, 0.051428571428571, 0.038461538461538, 0.039344262295082, 0.035928143712575 ],
      mul: [ 1, 0.031622776601684, 0.15848931924611, 0.079432823472428, 0.03981071705535 ] );

    vo = BBandPass.ar(
      in: in,
      freq:[ 400, 750, 2400, 2600, 2900 ] ,
      bw: [ 0.1, 0.10666666666667, 0.041666666666667, 0.046153846153846, 0.041379310344828 ],
      mul: [ 1, 0.28183829312645, 0.089125093813375, 0.1, 0.01 ]);

    vu = BBandPass.ar(
      in: in,
      freq: [ 350, 600, 2400, 2675, 2950 ],
      bw: [ 0.11428571428571, 0.13333333333333, 0.041666666666667, 0.044859813084112, 0.040677966101695 ],
      mul: [ 1, 0.1, 0.025118864315096, 0.03981071705535, 0.015848931924611 ]);

    snd = snd + Pan2.ar(SelectX.ar(Lag.kr(temp_vowel, temp_lag), [va, ve, vi, vo, vu]), i.linlin(0, 4, -1, 1));
  };

  snd = Compander.ar(snd, snd, -30.dbamp, 1, 0.5, 0.01, 0.1) * 6.dbamp;

  snd = FreeVerb2.ar(snd[0], snd[1], 0.5, 1, 1);

	Out.ar(0, snd * env * amp);
}).add;
)

(
x=Pmono(
	"Choir",
  \note, Pwrand([0, 2, 4, 5, 7, 9,3,9,7,1], [5, 2,7, 3, 3, 4,5, 1, 0].normalizeSum, inf),
	\ctranspose, -14,
  \dur, Pstutter(Prand([1, 2, 4], inf), Pwrand([1, 0.5, 0.25], [1, 2, 1].normalizeSum, inf)),
  \amp, Pbrown(-9, -3, 0.1).dbamp,
	\vibratoSpeed, Pwhite(4, 5),
	\vibratoDepth, 2,
	\vowel, Pwrand([0, 1, 2, 3, 4], [4, 3, 2, 1, 1].normalizeSum, inf),
	\lag, 0.5
).play;
)

(
y=Pmono(
	"Choir",
  \note, Pwrand([3, 7, 5, 5, 8, 9], [2, 3, 1, 1, 2, 0,5].normalizeSum, inf),
	\ctranspose, -14,
  \dur, Pstutter(Prand([1, 2, 7], inf), Pwrand([1, 0.5, 0.25], [1, 3, 1].normalizeSum, inf)),
  \amp, Pbrown(-12, -6, 0.1).dbamp,
	\vibratoSpeed, Pwhite(4, 5),
	\vibratoDepth, 2,
	\vowel, Pwrand([4, 3, 2, 1, 1], [4, 3, 2, 1, 1].normalizeSum, inf),
	\lag, 0.5
).play;
)

(

z=Pmono(
	"Choir",
  \note, Pwrand([3, 9, 5,6, 8, 9], [2, 3, 1, 3, 2, 7, 0,5].normalizeSum, inf),
	\ctranspose, -14,
  \dur, Pstutter(Prand([1, 2, 7], inf), Pwrand([1, 0.5, 0.25], [1, 3, 1].normalizeSum, inf)),
  \amp, Pbrown(-12, -6, 0.1).dbamp,
	\vibratoSpeed, Pwhite(4, 5),
	\vibratoDepth, 2,
	\vowel, Pwrand([3, 4, 5, 6, 7,8,9], [9, 8, 7, 6,5,4,3].normalizeSum, inf),
	\lag, 0.5
).play;
)


