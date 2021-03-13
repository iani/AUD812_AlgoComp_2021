// 26 Nov 2020 14:23
// «spinback» by AdamArmfield on 03 May'13 15:23 in sctweetspinbackbubbles

// from http://sccode.org/1-4TA
//spinback
play{a = PMOsc;b= SinOsc;c=RLPF;d=440;a.ar(c.kr(b.kr(20,0,d),b.kr(0.2,0,d))) * 0.01 }// #supercollider