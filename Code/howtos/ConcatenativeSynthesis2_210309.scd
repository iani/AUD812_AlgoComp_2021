//  9 Mar 2021 14:16
/*
Introduction to concatenative synthesis.
(Copy of examples from doc.sccode.org).
*/
//================================================================
//:from: https://doc.sccode.org/Classes/Concat2.html
b = Buffer.read(s,"sounds/a11wlk01.wav");


//match only on amplitude from audio in
(
SynthDef(\concat1, {arg bufnum, matchlength=0.01, freeze=0;
var concat, control, input;

control= SoundIn.ar;

input=PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum), loop:1);

concat= Concat2.ar(control,input,1.0,1.0,1.0,matchlength,freeze,0.0,1.0,0.0,0.0);

Out.ar(0,Pan2.ar(concat,0.0))}).add;
)

a=Synth(\concat1,[\bufnum, b.bufnum]);

a.set(\freeze, 0);

a.set(\matchlength, 0.01);







//synthesis controls audio in- beat box, then the synth drives bits of audio rhythmically
(
{
var concat, control, input;

control= SinOsc.ar(0.5)*Saw.ar(SinOsc.kr(LFNoise0.kr(MouseY.kr(0.01,1),3,4.5),0,50,MouseY.kr(120,500)));

input=SoundIn.ar;

concat= Concat2.ar(control,input,4.0,4.0,4.0,MouseX.kr(0.0,0.5),0,0.5,1.0,0.5,0.0);

Out.ar(0,Pan2.ar(concat,0.0))}.play
)



//audio in controls synthesis, low latency, match by ZCR and spec centroid
(
{
var concat, control, input, amp;

input= SinOsc.ar(2)*
Mix(Gendy3.ar(3,5,1.0,1.0,(Array.fill(5,{LFNoise0.kr(1.3.rand,1,2)})*MouseY.kr(100,3780,'exponential')),MouseY.kr(0.01,0.05),MouseY.kr(0.001,0.016),5,mul:0.1));

control=SoundIn.ar;

amp=Amplitude.ar(control);

concat= Concat2.ar(control,input,1.0,1.0,1.0,MouseX.kr(0.0,0.1),0,1.0,0.0,1.0,1.0);

Out.ar(0,Pan2.ar(10*concat*amp,0.0))}.play
)



//granulator
(
{
var concat, control, input;

control= Saw.ar(SinOsc.kr(LFNoise0.kr(MouseY.kr(0.01,1),3,4.5),0,10,MouseY.kr(12,100)));

input=PlayBuf.ar(1,b.bufnum,BufRateScale.kr(b.bufnum), loop:1);

concat= Concat2.ar(control,input,2.0,2.0,2.0,MouseX.kr(0.01,0.1),0,MouseY.kr(0.0,1.0),1.0,0.5);

Out.ar(0,Pan2.ar(concat,0.0))}.play
)





b = Buffer.read(s,"sounds/break2");


//beat resynthesis match by ZCR and spec centroid
(
SynthDef(\concatexample2, {arg bufnum, freeze=0;
var concat, control, input, amp;

input= SoundIn.ar;

control=PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum), loop:1);

amp=Amplitude.ar(control);

concat= Concat2.ar(control,input,5.0,5.0,5.0,MouseX.kr(0.0,0.1),freeze,MouseY.kr(0.0,1.0),0.0,1.0);

Out.ar(0,Pan2.ar(10*concat*amp,0.0))
}).add;
)


a=Synth(\concatexample2,[\bufnum, b.bufnum]);

a.set(\freeze, 1); //set this on or off to stay with a set of collected sounds

a.set(\freeze, 0); //set this on or off to stay with a set of collected sounds