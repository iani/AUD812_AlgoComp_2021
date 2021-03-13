//: 26 Nov 2020 11:48
// «..and tweets» by aucotsi (G. D.)
// from: http://sccode.org/1-4RE
// 01
play{a=SinOsc.ar(_);g=Stepper.ar(_);f=111!2+(148*a.(3.0166));FreeVerb.ar(HPF.ar(a.(2**f)/3,7e3)+a.(g.(a.(2))*444/g.(f)))}// #SuperCollider

// 02
play{a=SinOsc.ar(_);b=LFPulse.ar(_);g=Stepper.ar(_);Splay.ar(HPF.ar(a.({|i| f=111!2+(148*a.(1/i));g.(b.(i.sqrt))*(444/i)/g.(f) }!12,123)))}

// 03
play{a=SinOsc;b=LFPulse;g=Stepper;Splay.ar(HPF.ar(a.ar({|i|f=111!2+(148*a.ar(1/i));g.ar(b.ar(i))*(444/i)/g.ar(f)}!8,123).tanh))}// #sc140

// 04
SynthDef(\,{|f,j|Out.ar(0,LFTri.ar(f!2)/8*Line.ar(2,1,j,1,0,2))}).add;29.do{|i|Pbind(\instrument,\,\f,(i+1)%9*88,\dur,i+1/9,\j,i/99).play}

// 05 - nasty for cpu ~8k ugens, ~40% on my machine
d=Dust;a=SinOsc;300.do{|i|{a.ar(Stepper.kr(d.kr(1),0,0,t=TChoose.kr(d.kr(3),(4..7)))*129+[a.kr(t),a.kr(t+1).neg],a.kr(i/t),i+1*1e-4)}.play}
