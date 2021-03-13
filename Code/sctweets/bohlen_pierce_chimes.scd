// 26 Nov 2020 14:31
// «Bohlen-Pierce Chimes» by Jacob Joaquin on 26 Aug'11 09:05 in sctweet
// from: http://sccode.org/1-W

// Note:  * 0.1 added by IZ
fork{loop{play{f=_*3.pow(17.rand/13);e=EnvGen.ar(Env.perc,1,0.3,0,1,2);PMOsc.ar(f.([438,442]),f.(880),f.(e))*e * 0.1};[1/6,1/3].choose.wait}};