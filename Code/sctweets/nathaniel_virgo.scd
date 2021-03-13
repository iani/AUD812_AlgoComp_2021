// 26 Nov 2020 14:00
// «SCTweets» by nathanielvirgo on 26 Aug'11 09:05 in tweetssctweets
// From: http://sccode.org/1-V

{a=PinkNoise.ar(1!2);50.do{a=BBandStop.ar(a,LFNoise1.kr(0.05.rand).exprange(40,15000),exprand(0.1,2))};LPF.ar(a,1e5)}.play// #supercollider
{a=LFTri.ar(1);20.do{a=BAllPass.ar(a,80,1);a=((a+0.02)*LFNoise0.kr(1/2)*8).tanh;a=LeakDC.ar(a,0.995)};a*0.1!2}.play// #supercollider
p={|f,a=1|LFPulse.ar(f)*a*[1,1.01]};{p.(p.(100-p.(1/16,20))+p.(2,1+p.(1/4))-0.5*200)+p.(100-p.(1/8,20),p.(8))*0.1}.play// #supercollider
f=0;Routine({inf.do{|i|f=i/12+f%[4,3];{Formant.ar(2**f*100,2**(i%8*f*0.2)*100,100)*Line.kr(0.1,0,1)}.play;0.25.wait;}}).play//#supercollider
{LocalOut.ar(a=CombN.ar(BPF.ar(LocalIn.ar(2)*7.5+Saw.ar([32,33],0.2),2**LFNoise0.kr(4/3,4)*300,0.1).distort,2,2,40));a}.play//#supercollider
d={|l,h,f,p|({Ringz.ar(LFPulse.ar(f,p,0.01),exprand(l,h),0.5)}!20).sum};{d.(50,100,2,[0,1/4])+d.(3e3,1e4,4,0)+d.(2e2,3e3,1,0.5)*3e-4!2}.play
d={|l,h,f,p,n|sum({Ringz.ar(LFPulse.ar(f,p,0.01),exprand(l,h).round(n),0.5)}!20)};{d.(50,150,[2,1,1],[0,1/4,3/4],[1,40,50])*3e-4!2}.play
x=LFPulse;d={|l,h,f,p,n|sum({Ringz.ar(x.ar(f,p,0.01),exprand(l,h).round(n),0.6)}!40)};{d.(30,150,2,[0,0.3],[1,x.kr(1/8)*10+40])*3e-4!2}.play
n={|r,f,d=1|2**LFNoise0.kr(1!d,r)*f};{p=n.(4,1e3);CombN.ar(Ringz.ar(LFPulse.ar(1,0,0.01),n.(2,p,80),0.6).sum,8/5,8/5,60)*4e-4!2}.play
n={|r,f,n=0,d=1|round(r**LFNoise0.ar([4,1,8,2]!d)*f,n)};play{Splay.ar(d=n.(3,0.6);Ringz.ar(d*0.01,n.(2,n.(20,400),40,20),d).mean.tanh)}
p={|f,a=5|GVerb.ar(LFPulse.ar(f)*a)+f};play{tanh(HPF.ar(p.(99-p.(1/2,20)*(1+p.(2,1/5))+p.(4+p.(1/2)),0.5),80,XLine.kr(4e-4,1/8,61,1,0,2)))}
x=0;Pbind(*[type:\set,id:{|freq=10|LFTri.ar(freq.lag(0.1))!2}.play.nodeID,freq:Pfunc{x=x+32%355;x%12+1*40},dur:1/6]).play// #supercollider
x=0;Pbind(*[type:\set,id:{|freq=10|f=freq;LPF.ar(Saw.ar(f),f.lag(1)*3)!2}.play.nodeID,freq:Pfunc{x=x+32%35;x%12+1*40},dur:1/6]).play
play{p=PinkNoise.ar(1!2);BRF.ar(p+Blip.ar(p+2,400),150,2,0.1)+LPF.ar(FreeVerb2.ar(*LPF.ar(p+0.2*Dust.ar(0.1),60)++[1,1,0.2,1e4]).tanh,2000)}
Ndef('x',{Normalizer.ar(FreqShift.ar(Rotate2.ar(*Ndef('x').ar++1/8).tanh,20*[-3,0.995])+Dust.ar(1!2,0.005),1,0.5)}).play// #supercollider
Ndef(\x,{DelayN.ar(BRF.ar(Saw.ar(20!2)*0.01+Rotate2.ar(*(Ndef(\x).ar*2).tanh++0.1),20**LFNoise1.kr(0.6)*500,1),1,1)}).play// #supercollider
b=Buffer.read(s,"sounds/a11wlk01.wav");play{t=Impulse.kr(5);PlayBuf.ar(1,b,1,t,Demand.kr(t,0,Dseq(1e3*[103,41,162,15,141,52,124,190],4)))!2}
Ndef('x',{x=(Ndef('x').ar*1.8).tanh;BPF.ar(x+[0.01,0.1],12**Latch.ar(x.mean,Impulse.ar(3)).lag(0.1)*200)})// tin whistle #supercollider
Ndef('x',{x=Ndef('x').ar+0.01;a=BPF.ar(x,6**Latch.ar(x,Dust.ar(x))*200,0.1).sin;9.do{a=AllpassN.ar(a,0.2,{0.2.rand}!2,9)};a+a.mean}).play;
f=g=0;Routine({loop{g=g+1e-3;f=f+g%1;play{l=Line.kr(1,0,3,doneAction:2);h=2**f*100;e=Pluck.ar(CuspL.ar,1,i=1/h,i,2,0.3)!2};0.15.wait}}).play
a=1@2;f=1;w=Window().front.drawHook_({900.do{Pen.line(a*200,(a=(a*(f=f+2e-6)).y.cos+1@a.x)*200)};Pen.stroke});AppClock.play{w.refresh;0.01}
p={|f,a=5|GVerb.ar(LFPulse.ar(f)*a)+f};play{tanh(HPF.ar(p.(99-p.(1/2,20)*(1+p.(2,1/5))+p.(4+p.(1/2)),0.5),80,XLine.kr(4e-4,1/8,61,1,0,2)))}
n={|r,f,n=0,d=1|round(r**LFNoise0.ar([4,1,8,2]!d)*f,n)};play{Splay.ar(d=n.(3,0.6);Ringz.ar(d*0.01,n.(2,n.(20,400),40,20),d).mean.tanh)}
x=0;Pbind(*[type:\set,id:{|freq=10|LFTri.ar(freq.lag(0.1))!2}.play.nodeID,freq:Pfunc{x=x+32%355;x%12+1*40},dur:1/6]).play// #supercollider
play{p=PinkNoise.ar(1!2);BRF.ar(p+Blip.ar(p+2,400),150,2,0.1)+LPF.ar(FreeVerb2.ar(*LPF.ar(p+0.2*Dust.ar(0.1),60)++[1,1,0.2,1e4]).tanh,2000)}
Ndef('x',{Normalizer.ar(FreqShift.ar(Rotate2.ar(*Ndef('x').ar++1/8).tanh,20*[-3,0.995])+Dust.ar(1!2,0.005),1,0.5)}).play// #supercollider
b=Buffer.read(s,"sounds/a11wlk01.wav");play{t=Impulse.kr(5);PlayBuf.ar(1,b,1,t,Demand.kr(t,0,Dseq(1e3*[103,41,162,15,141,52,124,190],4)))!2}
b=Buffer.read(s,"sounds/a11wlk01.wav");play{t=Impulse.kr(6);BufGrain.ar(t,0.3,b,1,Demand.kr(t,0,Dseq([26,8,11,42,44,3,5,37,4,32,45]/50,4)))}
Ndef('x',{x=Ndef('x').ar+0.01;a=BPF.ar(x,6**Latch.ar(x,Dust.ar(x))*200,0.1).sin;9.do{a=AllpassN.ar(a,0.2,{0.2.rand}!2,9)};a+a.mean}).play;
a=1@2;f=1;w=Window().front.drawHook_({900.do{Pen.line(a*200,(a=(a*(f=f+2e-6)).y.cos+1@a.x)*200)};Pen.stroke});AppClock.play{w.refresh;0.01}
Ndef(\,{LPF.ar(x=DelayN.ar(LeakDC.ar(Ndef(\).ar,1-2e-6)*0.99,1,0.01)+Dust.ar(0.5!2);x+(Trig1.ar(x<(x.mean.lag(30)),4e-3)*0.05),800)}).play
Ndef(\,{x=DelayL.ar(n=Ndef(\);n.ar,2,LFNoise0.kr(0.03*_!20)+1)+Blip.ar(0.5);LeakDC.ar(LPF.ar(x+x.mean*0.15,4e3)).sin});play{Splay.ar(n.ar)}
play{w=LFSaw;a=w.ar(-3,1)+1/2;f=Sweep.ar(0,3).floor;f=(f**3+f%8+4)*(f%3+3)%49*3;CombN.ar(RLPF.ar(w.ar(f)*a,f**a*30,0.3).tanh,5/6,5/6,6)!2}
play{PitchShift.ar(CombN.ar(Formant.ar(101,4**LFNoise1.kr(0.5)*450,200),1,0.5,99),1,Duty.kr(4,0,Dseq([[6,8,10],[6,7.2,7]]/8,inf))).sum/25!2}
Ndef(\,{x=DelayN.ar(LeakDC.ar(Ndef(\).ar),1,z=1e-2);LPF.ar(Trig1.ar(Amplitude.kr(x,5,120)*1.5+x+z-Dust.ar(2),4e-3)*0.1+x*0.99,1200)}).play
play{b=LocalBuf(1e5,2).clear;x=BufRd.ar(2,b,Phasor.ar(0,1,0,1e5))*0.6;BufWr.ar(Blip.ar([1,1.01],10)/5+x,b,LFNoise1.ar(0.2)+1*5e4);x}// #sc
play{b=LocalBuf(4e5,2).clear;BufCombL.ar(b,LeakDC.ar(BufRd.ar(2,b,LFNoise1.ar(0.25)+1*2e5)*0.98)+Blip.ar(2!2,10),2,20)/10}// #supercollider
play{b=LocalBuf(4e5,2).clear;BufCombL.ar(b,LeakDC.ar(LPF.ar(PlayBuf.ar(2,b,16/15,0,0,1),300))+Blip.ar([20,21],1),2,40)/20}// #supercollider
play{b=LocalBuf(2*SampleRate.ir,2);BufCombL.ar(b,LeakDC.ar(RLPF.ar(Limiter.ar(PlayBuf.ar(2,b,0.4,0,0,1),0.5)+Dust.ar(0.1),5e3,0.03)),1,10)}
play{({|i|x=Dbufrd(b=LocalBuf(5).clear,i);x=x**x-LFNoise0.ar(1/(2**i),50).floor%16;Pulse.ar(Duty.ar(1/8,0,Dbufwr(x,b,i))*20)}!5).mean!2}
play{x=Splay.ar({|i|RLPF.ar(0.6**i*40*Impulse.ar(2**i/32,1/2),4**LFNoise0.kr(1/16)*300,5e-3).sin}!8);2.do{x=FreeVerb2.ar(*x++[0.1,1,1])};x}
play{Splay.ar({|i|f=1.9**i/128;BPF.ar(PinkNoise.ar(1!2),4**LFNoise2.kr(1.2**i/16)*300,0.15)*(5**LFNoise2.ar(f)/(i+8)*20)}!15)}
play{x=Saw.ar([50,50.1]);8.do{|i|f=2**(8-i);x=BRF.ar(AllpassN.ar(x,1,0.1/(12-i),2),80**TRand.ar(0,1,Impulse.ar(f/32,1/2)).lag(1/f)*80,2)};x}
p=Impulse;play{mean({|i|Pluck.ar(LFSaw.ar([102,101]),x=p.ar(1,i/10)+p.ar(0),1,1/Latch.ar(1.015**Sweep.ar(0,1)*64%1+1*200,x),4,0.2)}!10)}
p=SCImage(n=300);n.do{|i|n.do{|j|z=c=Complex(i-240,j-150)/n*2.5;{(r=rho(z=z*z+c)/8)>1&&{z=0}}!200;p.setColor(Color.hsv(r,1,1),i,j)}};p.plot
x=Ndef(\x,Pbind(\freq,Pseq(a=(3..5);a/.x a*.x[40,80],8)));Ndef(\,{Limiter ar:GVerb.ar(PitchShift.ar(Ndef ar:\,1,2,0,0.1),30,9)/4+x.ar}).play
x=Ndef(\x,Pbind(\freq,Pseq(a=(3..5);a*.x a*.x[4,8],8)));Ndef(\,{Limiter ar:GVerb.ar(PitchShift.ar(Ndef ar:\,1,2,0,0.1),20,20)/4+x.ar}).play
play{GVerb.ar(LFTri.ar(Duty.ar(Dseq([3,1]/12,inf),0,Dseq(x=(3..6);allTuples(x/.t x).flat*[100,200,400]++0))),25,5)/5} // #supercollider
play{GVerb.ar(Saw.ar(Duty.ar(1/8,0,Dseq(x=[5,2,9,3];1/(flat(allTuples(x/.t x).reject(any(_,{|i|i%1==0}))/.-1 x)%1)*30++0))),165,5)/5}
play{GVerb.ar(Saw.ar(Duty.ar(1/8,0,Dseq(x=[5,2,[9,7],3];1/(flat(allTuples(x/.t x).reject(any(_,{|i|i%1==0}))/.-1 x)%1)*30++0))),165,1)/5}
play{GVerb.ar(Pulse.ar(Duty.ar(1/8,0,Dseq(x=[5,2,7,3];1/flat(allTuples(x/.t x).reject(any(_,{|i|i%1==0}))%1)*.x[1,3,2,6]*40++0))),165,7)/5}
t={|u,d,a|u.ar(Duty.ar(d/5,0,Dseq(a++0))*300)};play{t.(Saw,1,x=[6,5,9,8];flat(y=allTuples(x/.t x)[(127..1)+[0,127]]%1))+t.(LFTri,4,y*2)!2/6}
play{GVerb.ar(VarSaw.ar(Duty.ar(1/5,0,Dseq(x=[[4,4.5],[2,3,5,6]];flat(x*.x allTuples(x*.x x)*4).clump(2)++0)),0,0.9)*LFPulse.ar(5),99,5)/5}
f=0;{inf.do{|i|f=f+log2(2*i%6+1+floor(f)/(i%5+1))%2;play{SyncSaw.ar(2**f*99+[0,1],i%8+2*52)*Line.kr(0.1,0,1,1,0,2)};0.3.wait}}.r.play