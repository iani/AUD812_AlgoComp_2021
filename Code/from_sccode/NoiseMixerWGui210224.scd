//: 24 Feb 2021 15:59
/* https://sccode.org/1-5et#c955
«Simple noise mixer with GUI» by pHJosef
on 24 Jan'21 14:02 in noisecolorfiltermixereq

a simple noise eq with 10 filter bands and a gui.

*/

(
Ndef(\x).clear;
Ndef(\x, {
	|amp1 = 0, amp2 = 0, amp3 = 0, amp4 = 0, amp5 = 0, amp6 = 0,
	amp7 = 0, amp8 = 0, amp9 = 0, amp10 = 0, rq = 0.8|
	var freq1=36, freq2=75, freq3=157, freq4=329, freq5=688, freq6=1440, freq7 = 3013,
	freq8 = 6303, freq9=13184, freq10=18000;

	var sig = [PinkNoise.ar(1), PinkNoise.ar(1)];
	sig = BPeakEQ.ar(sig, freq1, rq, amp1);
	sig = BPeakEQ.ar(sig, freq2, rq, amp2);
	sig = BPeakEQ.ar(sig, freq3, rq, amp3);
	sig = BPeakEQ.ar(sig, freq4, rq, amp4);
	sig = BPeakEQ.ar(sig, freq5, rq, amp5);
	sig = BPeakEQ.ar(sig, freq6, rq, amp6);
	sig = BPeakEQ.ar(sig, freq7, rq, amp7);
	sig = BPeakEQ.ar(sig, freq8, rq, amp8);
	sig = BPeakEQ.ar(sig, freq9, rq, amp9);
	sig = BPeakEQ.ar(sig, freq10, rq, amp10);
	sig = Limiter.ar(sig * 0.1, 1, 0.01);

}).play;
//    ----------- :
try{~win.close};
~win = Window('noise mixer', Rect(400,400,600,300));
~win.front.alwaysOnTop_(true);
~reset = {
	b.value_(0.31);
	a.do{ |sl| sl.value_(0.5)};
	Ndef(\x).resetNodeMap;
};
//    ---------------- :

a = {Slider(~win, Rect(0, 0, 20, 100)).value_(0.5)} ! 10;
b = Slider(~win, Rect(0, 00, 10, 10)).value_(0.31).action_({ |sl|
	Ndef(\x).set(\rq, sl.value.linlin(0, 1, 0.1, 3).postln)});
c = StaticText().string_("Filter Bands").align_(\center);
d = StaticText().string_("Q Factor").align_(\center);
e = Button().states_([["reset"]]).action_({ ~reset.value});

~win.layout = HLayout(
	VLayout(c, HLayout(*a)),
	VLayout(d, b),
	e
);

a.do{ |ins, c=0| c = c+1; ins.addAction({ |sl|
	~sl = sl.value;
	~low = -24;
	~high = 24;
	switch(c,
		1, {Ndef(\x).set(\amp1, ~sl.linlin(0, 1, ~low, ~high).postln)},
		2, {Ndef(\x).set(\amp2, ~sl.linlin(0, 1, ~low, ~high).postln)},
		3, {Ndef(\x).set(\amp3, ~sl.linlin(0, 1, ~low, ~high).postln)},
		4, {Ndef(\x).set(\amp4, ~sl.linlin(0, 1, ~low, ~high).postln)},
		5, {Ndef(\x).set(\amp5, ~sl.linlin(0, 1, ~low, ~high).postln)},
		6, {Ndef(\x).set(\amp6, ~sl.linlin(0, 1, ~low, ~high).postln)},
		7, {Ndef(\x).set(\amp7, ~sl.linlin(0, 1, ~low, ~high).postln)},
		8, {Ndef(\x).set(\amp8, ~sl.linlin(0, 1, ~low, ~high).postln)},
		9, {Ndef(\x).set(\amp9, ~sl.linlin(0, 1, ~low, ~high).postln)},
		10, {Ndef(\x).set(\amp10, ~sl.linlin(0, 1, ~low, ~high).postln)},

)});
}
)

//: --------------------