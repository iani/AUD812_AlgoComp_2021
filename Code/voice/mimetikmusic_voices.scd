/* 14 Jan 2021 12:57 Voices
(Not very vocal-like, but still interesting)
*/
/* Voices

http://www.kimri.org/blog/?p=64

 */

(

SynthDef(\voice,{arg out=0,n=0,p=0,d=10,r=10;
var sig=Array.fill(3,{|i| VarSaw.ar(n.midicps*(i+1.0001),mul:0.05/(i+1))}).sum;
var sig2=Ringz.ar(WhiteNoise.ar(0.0003),TRand.ar(n.midicps,(n+1).midicps,Impulse.ar(10)));
var env=EnvGen.kr(Env.linen(d,1,r),gate:1,doneAction:2);
Out.ar(out,Pan2.ar((sig+sig2)*env*(0.8+SinOsc.kr(0.1,0,0.2)),p));
}).add;

)
//:
(
Ndef(\rev,{
Out.ar(0,Limiter.ar(FreeVerb.ar(LPF.ar(In.ar([0,1]),10000),mix:0.33),0.7));
});
)
//:
(
Tdef(\voices,{
inf.do{
10.do{
if ((0.8).coin,{
Synth(\voice,[\n:[24,28,29,48,36,40,41,52,53,60,64,65].choose,\p:{rrand(-0.5,0.5)},\d:{rrand(5,13)},\r:{rrand(8,14)}]);
});
rrand(0.1,1).wait;
};
18.wait;
};
});
)
//:
Tdef(\voices).play;
//:
Tdef(\voices).stop;

