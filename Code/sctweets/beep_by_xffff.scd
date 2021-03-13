// 26 Nov 2020 14:07
// «beep» by xffff on 08 Jun'12 07:08 in sctweetbitwisebeep
// from http://sccode.org/1-4Qk
// Note : * 0.01 added by IZ to reduce volume

play{l=LFNoise0;a=[3,2];t=PulseCount.ar(Impulse.ar(l.kr(a,8e3-1,8e3)));Clip.ar(HPF.ar(t>>l.kr(a,6,7)|t&a),-1,1) * 0.01 }