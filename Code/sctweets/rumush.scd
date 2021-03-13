// 26 Nov 2020 14:02
// «Re: SCTweets» by rumush on 10 Nov'15 03:16 in tweetssctweetscode fork
// Rumush
// Facebook: https://www.facebook.com/rumushproduction
// SoundCloud: https://soundcloud.com/rumushproduction
// YouTube: https://www.youtube.com/channel/UCs_Cn1R4iFrYOyc8liFucSQ
// Blog: https://mycelialcordsblog.wordpress.com/

//:
(// Original – Inspiration
play{
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;
BufWr.ar(Blip.ar([1,1.01],10)/5+x,b,LFNoise1.ar(0.2)+1*5e4);
x
}
)
//:
(// Glitch Pitch
play{
var env = XLine.ar(0.5, 20, 60, doneAction:2);
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;
BufWr.ar(Blip.ar([1,1.01]*env,10)/5+x,b,Lag.ar(LFNoise0.ar(1*env)+1*5e4, 0.25));
x
}
)
//:
(// Simple Sine Glitch
play{
var seq = Demand.ar(Impulse.ar(0.25), 0, Dseq([[0, 1e5, 1000], [1e5, 0, 2000]], inf));
b=LocalBuf(1e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,seq[0],seq[1]))*0.6;
r=LFNoise0.ar(0.01).unipolar;
BufWr.ar(SinOsc.ar(seq[2], 0, Decay.ar(Impulse.ar(0.125), 2, 0.5))+x,b,LFNoise1.ar(0.5+LFPulse.ar([0.0125, 0.013], 0, 0.9, 0.01))+1*5e4);
(x).tanh
}
)
//:
(// Glitch Textures
play{
var pul = XLine.ar(1, 240, 240, doneAction:2)*(LFSaw.ar([2, 2.01])+1).round(0.25);
var tr = { arg rt=2, ph=0; Impulse.ar(rt, ph) };
var blip = Blip.ar(600, 4, 0.25);
var tone = SinOsc.ar(LFNoise0.ar(1*2).range(240, 480)+(blip*LFPulse.ar(1/4, mul:150)), 0, Decay2.ar(tr.(pul/4, 0.5), 1, 0.125));
p=TChoose.ar(tr.(1/4),[LFNoise1.ar(1)+1*2e5,LFNoise1.ar(1/2)+1*2e5]);
b=LocalBuf(4e5,2).clear;
x=BufRd.ar(2,b,Phasor.ar(0,1,0,4e5))*0.125;
BufWr.ar(blip+tone+x,b,p)*0.125;
(x).tanh
}
)
//:
(// Gitch + Bluesy chords – Goes quite crazy after a while
play{
var src1, src2, src3, buf1, buf2;
var seq = Duty.ar(Dseq([0.25, 0.5], inf), 0, Dseq([40,64,65,66,59,62,69].midicps, inf));
buf1=LocalBuf(1e5,2).clear;
buf2=LocalBuf(1e5,2).clear;
src1=BufRd.ar(2,buf1,Phasor.ar(0,0.25,LFNoise0.ar(0.5, 1e5/8),1e5))*0.75;
src2=CombC.ar(src1*Decay.ar(Impulse.ar(0.8, 0.76), LFNoise1.ar(0.2)+1), 0.25, 0.25, 5);
src3=BufRd.ar(2,buf2,LFNoise1.ar(0.25)+1*1e5)*0.75;
BufWr.ar(Blip.ar([5, 6], 10)+src3,buf2,LFNoise1.ar(0.1)+1*5e4);
BufWr.ar(Saw.ar([seq*0.25, seq*0.251]+Crackle.ar(LFNoise1.ar(5).range(1.75, 1.99), 10))+src1,buf1,LFNoise1.ar(0.2)+1*5e4);

(src1+src2+src3)*0.25
}
)