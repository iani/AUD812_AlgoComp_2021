// 23 Dec 2020 18:58
//:Play immedately
{ SinOsc.ar(440, 0, 0.1).dup }.play;
//:play after 5 seconds
(
{
	5.wait;
	{ SinOsc.ar(440, 0, 0.1).dup }.play;
}.fork;
)
//:play some more stuff .... ;-)
(
{
	var s1, s2;
	0.5.wait;
	s1 = { SinOsc.ar(440, 0, 0.1).dup }.play;
	1.wait;
	s1.release(2);
	2.5.wait;
	s2 = Synth(\default, [freq: 1000]);
	1.wait;
	s2.release(0.2);
}.fork;
)
//: using functions to package and repeat code.
//: step 1: package the code and store it in function ~frasi1
(
~frasi1 = {
	var s1, s2;
	0.5.wait;
	s1 = { SinOsc.ar(440, 0, 0.1).dup }.play;
	1.wait;
	s1.release(2);
	2.5.wait;
	s2 = Synth(\default, );
	1.wait;
	s2.release(0.2);
};
)
//: Step 2: evaluate the function
// NOTE: The function MUST run inside a routine, because it contains "wait".
// To make a routine, use "fork".
// see also: yield.
(
{
	~frasi1.value;
}.fork;
);
//: Step 3: repeat the function.
(
{
	5 do: {
		~frasi1.value;
		/*
		NOTE: This repeats the function IN SEQUENCE.
		To play in parallel, you need to fork it. See below
		*/
		1.5.wait;
	};
}.fork;
);
//: Step 4: Repeat the function a phrase in parallel (concurrently).
(
{
	5 do: {
		{ ~frasi1.value }.fork;
		0.1.wait;
	};
}.fork;
);

//: Step 4: Repeat the function a phrase in parallel (concurrently).
(
~frasi1 = {
	var s1, s2;
	0.5.wait;
	s1 = { SinOsc.ar(440 rrand: 2000, 0, 0.1).dup }.play;
	1.wait;
	s1.release(2);
	2.5.wait;
	s2 = Synth(\default, [freq: 400.rrand(2000)]);
	1.wait;
	s2.release(0.2);
};
{
	5 do: {
		{ ~frasi1.value }.fork;
		0.1.wait;
	};
}.fork;
);


//: Step 5: Repeat for ever
(
~frasi1 = {
	var s1, s2;
	0.5.wait;
	s1 = { SinOsc.ar(440 rrand: 2000, 0, 0.1).dup }.play;
	1.wait;
	s1.release(2);
	2.5.wait;
	s2 = Synth(\default, [freq: 400.rrand(2000)]);
	1.wait;
	s2.release(0.2);
};
{
	loop {
		{ ~frasi1.value }.fork;
		1.5.wait;
	};
}.fork;
);


//: ps link for soundwalk
/*
https://aruku-geidai.coton.jp/#-1v
*/