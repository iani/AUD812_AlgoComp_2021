//: 24 Feb 2021 15:57
/* https://sccode.org/1-5eu
«Make Noise 0-Coast» by bgola
on 18 Feb'21 04:45 in synthmodular0coastmakenoise

Trying to replicate the Make Noise 0-Coast semi-modular synth design 

Inspired by https://www.youtube.com/watch?v=gQCmjEgFgS4

*/

// Trying to replicate the Make Noise 0-Coast semi-modular synth design
// by https://bgo.la/
//: Inspired by https://www.youtube.com/watch?v=gQCmjEgFgS4

(
Ndef(\nocoast).addSpec(\saturation, [0.2, 12, \lin]);
Ndef(\nocoast).addSpec(\fold, [0, 1, \lin]);
Ndef(\nocoast).addSpec(\slopeAtt, [-1, 1, \lin]);
Ndef(\nocoast).addSpec(\curve, [-10, 10, \lin]);
Ndef(\nocoast).addSpec(\rise, [0.01, 4, \lin]);
Ndef(\nocoast).addSpec(\fall, [0.01, 4, \lin]);
Ndef(\nocoast).addSpec(\dyn, [0, 1, \lin]);
Ndef(\nocoast).addSpec(\onset, [0.0, 4, \lin]);
Ndef(\nocoast).addSpec(\decay, [0.0, 4, \lin]);
Ndef(\nocoast).addSpec(\sustain, [0.0, 1, \lin]);
Ndef(\nocoast).addSpec(\contourCurve, [-10, 10, \lin]);
Ndef(\nocoast).addSpec(\slopeLoop, [0, 1, \lin, 1]);
Ndef(\nocoast).addSpec(\ogate, [0.0, 1, \lin]);
Ndef(\nocoast).addSpec(\balance, [-1, 1, \lin]);
Ndef(\nocoast).addSpec(\att, [0.1, 2000, \exp, 1]);
Ndef(\nocoast, { arg freq=60, clockFreq=1, saturation=1.0, fold=0.3, ogate=1, slopeAtt=0.6, curve=0, rise=0.2, fall=2,
	dyn=1, onset=0.0, decay=0.4, sustain=1.0, contourCurve=0, slopeLoop=1, balance=0, att=1;
	var clock = Impulse.ar(clockFreq);
	var trilfo = LFTri.ar(clockFreq);
	var sqrlfo = LFPulse.ar(clockFreq);
	var random = Latch.ar(WhiteNoise.ar, clock);
	var slope,contour,eoa,eos, osc;
	var overtone, dynamics, proc, lpf;
	contour = EnvGen.ar(Env.new([0,1,sustain,0], [onset, decay, decay], contourCurve, 2), ogate);
	eoa = BinaryOpUGen('==', contour, 1);
	slope = EnvGen.ar(Env.new([0,0,1,0,0], [0,rise,fall,0], curve, 3, Select.kr(slopeLoop, [2, 0])), ogate | slopeLoop);
	eos = BinaryOpUGen('==', slope, 0.0);
	osc = LFTri.ar(freq);
	overtone = (osc.pow((saturation))).tanh;
	fold = (fold + (slope*slopeAtt));
	fold = fold.clip(0.04,1);
	proc = Normalizer.ar(Fold.ar(overtone, fold.neg, fold));
	contour = contour * dyn;
	dynamics = LPF.ar(XFade2.ar(osc, proc, balance), contour.linexp(0,1, 20, 20000)) * contour.clip(0,1)!2;
	dynamics;
}).gui;
)


//: Krell patch:

(
Ndef(\nocoast, { arg freq=60, clockFreq=1, satu=1.0, fold=0.3, ogate=1, slopeAtt=0.6, curve=0, rise=0.2, fall=2,
	dyn=1, onset=0.0, decay=0.4, sustain=1.0, contourCurve=0, slopeLoop=1, balance=0, att=120;
	var clock = Impulse.ar(clockFreq);
	var trilfo = LFTri.ar(clockFreq);
	var sqrlfo = LFPulse.ar(clockFreq);
	var random = Latch.ar(WhiteNoise.ar, LocalIn.ar(1));
	var slope,contour,eoa,eos, osc;
	var overtone, dynamics, proc, lpf;
	contour = EnvGen.ar(Env.new([0,1,sustain,0], [onset, decay, decay], contourCurve, 2), ogate);
	eoa = BinaryOpUGen('==', contour, 1);
	slope = EnvGen.ar(Env.new([0,0,1,0,0], [0,rise+random,fall+random,0], curve, 3, Select.kr(slopeLoop, [2, 0])), ogate | slopeLoop);
	eos = BinaryOpUGen('==', slope, 0.0);
	LocalOut.ar(eos);
	osc = LFTri.ar(freq + (random*att));
	overtone = (osc.pow((satu))).tanh;
	fold = (fold + (slope*slopeAtt));
	fold = fold.clip(0.04,1);
	proc = Normalizer.ar(Fold.ar(overtone, fold.neg, fold));
	slope = slope * dyn;
	dynamics = LPF.ar(XFade2.ar(osc, proc, balance), slope.linexp(0,1, 20, 20000)) * slope.clip(0,1)!2;
	dynamics;
}).gui;
)