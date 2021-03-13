// 26 Nov 2020 14:21
// «more tweets (pitchshift feedback + sinoscfb)» by xffff on 16 Jul'12 15:27 in sctweetfeedbackglitchdistortion

// from: http://sccode.org/1-4QC
// probably horrible for speakers...
// Note: * 0.02, * 0.05 etc. added by IZ
// Larger values result in blow-up.

//: glitchift
{l=LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**[l,k],k),[0.05,0.03],j);LocalOut.ar(s);s * 0.02}.play;
//: drone
{l=LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**[2,2.1],k),[0.05,0.03],j);LocalOut.ar(s);s * 0.05}.play;


// few more I was mucking around with (remove tanh loop for < 140c)
{l = LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**l,k),[0.05,0.03],j);5.do{s=s.tanh+(s*0.1)};LocalOut.ar(s);s * 0.01}.play;
//:
{l = LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**2,k),[0.05,0.03],j);5.do{s=s.tanh+(s*0.1)};LocalOut.ar(s);s * 0.01 }.play;
//:
{l = LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j*20,k),[0.05,0.03],j);5.do{s=s.tanh+(s*0.1)};LocalOut.ar(s);s * 0.01}.play;
//:
{l = LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**j,k),[0.05,0.03],j);5.do{s=s.tanh+(s*0.1)};LocalOut.ar(s);s * 0.005}.play;
//:
{l = LocalIn.ar(2);k=LFSaw.ar(l,0,l,1);j=k.range(0.25,4.0);s=PitchShift.ar(SinOscFB.ar(j**l.abs,k),[0.05,0.03],j);5.do{s=s.tanh+(s*0.1)};LocalOut.ar(s);s * 0.01}.play;