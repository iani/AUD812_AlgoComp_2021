//: 14 Mar 2021 00:37
/*
Waveterraing synthesis - very basic examples from sccode.org

*/
//================================================================
// Example 1
//:prepare scopes
Server.default.scope;
Server.default.freqscope;

//: function for wave terrain example

f = { |x, y| sin(x) - (sin(y) * log(x * x + 1)) / 10 };

// check the surface produced by the function with GeoGebra
// https://www.geogebra.org/3d?lang=en%2010
// copy and paste this syntax into GeoGebra Input, it needs ln for the natural logarithm
// (sin(x) - (sin(y) * ln(x * x + 1))) / 10


// circular path through the terrain, mouse control for distance from origin

(
x = {
	var r = MouseX.kr(0, 25);
	// stereo expansion
	var phi = LFSaw.ar([50, 50.1], -1).range(0, 2pi);
	var x = r * cos(phi);
	var y = r * sin(phi);
	f.(x, y) * 0.2
	//	Limiter.ar(f.(x, y), 0.2)
}.play;
)
//:
x.release
//================================================================
// Example 2
//: Synthdef
(
SynthDef.new(\leopard, {
	/*:the 'leopard' function is sampled on a circle with
	given radius and centre coordinates.
	*/

	| radius=1, centreX=0, centreY=0
	/*:(float) defaults to unit circle at <0,0>*/
	, circlefreq=440, amp = 0.3 |
	/*:(float) speed at which the data on the cirkle is sampled*/
	var x, y, grey;
	x = centreX + (radius * SinOsc.ar(circlefreq));
	y = centreY + (radius * SinOsc.ar(circlefreq, pi/2));
	grey = (x.sin + y.sin).sqrt/2;
	Out.ar(0, amp * grey ! 2 * amp);
}).add;
)
//: Synth
(
c = Synth.new(\leopard, [
	\circlefreq, 15,
	\radius, 100,
	\centreX, 5,
	\centreY, 1
]);
)
//================================================================
// Example 3
//: Synthdef
(
SynthDef.new(\leopard_b, {
	arg radius=1, a_centreX=0, a_centreY=0, circlefreq = #[440, 440], amp = 0.2;
	var x, y, grey;
	x = a_centreX + (radius * SinOsc.ar(circlefreq));
	y = a_centreY + (radius * SinOsc.ar(circlefreq, pi/2));
	grey = (x.sin + y.sin).sqrt /2;
	Out.ar(0, grey * amp);
}).add;
)
//:Synth
(
c = Synth.new(\leopard_b, [
	\circlefreq, [70, 70.1],
	\radius, 10,
	\a_centreX, 1,
	\a_centreY, 1
]);
)
//:Modulating Synth Parameters
//:
a = Bus.control(s, 1);
b = Bus.control(s, 1);
//:
x = { Out.kr(a.index, SinOsc.kr(70.03) * LFDNoise3.kr(5).range(1, 10)) }.play;
y = { Out.kr(b.index, SinOsc.kr(70.06) * LFDNoise3.kr(5).range(1, 10)) }.play;
//:
c.map(\a_centreX, a.index);
c.map(\a_centreY, b.index);
//:

c.set(\a_centreX, 0.1);
x.free;
y.free;
c.free;