// 26 Nov 2020 13:52
// «esoteric tweet» by all n4tural on 14 Aug'11 05:51 in sctweetdrone
// from: http://sccode.org/1-D

// http://twitter.com/#!/alln4tural/status/99846300173991936
// http://soundcloud.com/tengototen/esoteric-tweet


fork{loop{h=[5,7,8].choose*(2**(2..8).choose);play{Splay.ar({SinOsc.ar(exprand(h,h+(h/64)),0,0.1)}!64)*LFGauss.ar(9,1/4,0,0,2)};2.wait}};

// really i wanted to do this:
fork{loop{h=([33,38,40].choose.midicps)*(2**((0 .. 5).choose));play{Splay.ar({SinOsc.ar(exprand(h-(h/256),h+(h/256)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};4.wait}};
// or more like a constant drone:
fork{loop{h=([33,38,40].choose.midicps)*(2**((0 .. 4).choose));play{Splay.ar({SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!8)*LFGauss.ar(19,1/4,0,0,2)};0.25.wait}};
// primes
fork{loop{h=(4 .. 100).choose.nthPrime*(2**(0..3).choose);play{Splay.ar({SinOsc.ar(exprand(h-(h/256),h+(h/256)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};2.wait}};
// Fibonacci
fork{loop{h=(List.fib(15).choose)*(2**(0..4).choose);play{Splay.ar({SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!64)*LFGauss.ar(19,1/4,0,0,2)};2.wait}};

// but they were too long.
// __________________________
// inspired by http://sctweets.tumblr.com/post/8379573991/sinosc
// (http://soundcloud.com/rukano)