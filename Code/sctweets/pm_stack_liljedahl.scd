// 26 Nov 2020 14:25
// «PM stack tweet» by Jonatan Liljedahl on 09 Aug'11 04:43 in sctweettechnophasemodulation
// from http://sccode.org/1-8
// * 0.01 added by IZ
play{x=0;(50..120).do{|f|f=f/2;x=SinOsc.ar(f+[0,1],x*Line.kr(1,3,240,doneAction:2))};tanh(x+Ringz.ar(Impulse.ar(2),45,0.3,3)) * 0.01 }