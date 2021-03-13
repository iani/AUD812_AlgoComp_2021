// «three sines in a fountain» by AdamArmfield on 03 May'13 15:21 in sctweetsinedissonant
// from: http://sccode.org/1-4Tz
// Note: * 0.01 added by IZ
//
play{a=SinOsc;b=432;c=0.61538;a.kr(0.125).if(a.kr(0.25).if(a.ar(b),a.ar(b*c)),a.ar(b*c*c),a.ar(b*c*c*c)) * 0.01 }// #supercollider