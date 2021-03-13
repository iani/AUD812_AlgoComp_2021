Pbind(\dur, 1).play;

Pbind(\dur, 1, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 1)).play;

Pbind(\dur, 1, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 1), \amp, 0.3).play;

Pbind(\dur, 0.1, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 1), \amp, 2).play;


~p1 = Pbind(\dur, 0.1, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 3), \amp, 2).play;

~p2 = Pbind(\dur, 0.1, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], inf), \amp, 2).play;

~p2.stop;

Pbind(\dur, 0.2, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 3), \amp, 0.2).play;


Pbind(\dur, 0.25, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 3), \amp, 0.2, \scale, Scale.hijaz).play;

Scale.all.put(\catastrophic, Scale([0, 0.1, 0.4, 11.2]));

Pbind(\dur, 0.5, \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 10), \amp, 2, \scale, Scale.catastrophic).play;

Pbind(\dur, Prand([0.1, 0.2], inf), \degree, Pseq([0, 1, 2, 3, 1, 2, 0, 4], 3), \amp, 2).play;




Pbind(\dur, Prand([0.1, 0.2], inf), \degree, Prand([0, 1, 2, 3, 1, 2, 0, 4], inf), \amp, 2).play;

Pbind(\dur, Prand([0.1, 0.2], inf), \degree, Pbrown(0, 12, 2, inf), \amp, 2).play;


Pbind(\dur, 0.05, \degree, Pbrown(-10, 12, 2, inf), \amp, 2).play;

Pbind(\dur, 0.15, \degree, Pbrown(-10, 12, 2, inf) + Pseq([0, [0, 2, 4]], inf), \amp, 2).play;

Pbind(\dur, 0.1, \degree, Pbrown(-10, 12, 2, inf) + Prand([0, [0, 2, 4]], inf), \amp, 2).play;

Pbind(\dur, 0.1, \degree, Pbrown(-10, 12, 2, inf) + Prand([0, [0, 2]], inf), \amp, 2).play;

Pbind(\dur, 0.1, \midinote, Pbrown(-10, 12, 2, inf) + 50 + Prand([0, [0, 2]], inf), \amp, 2).play;

Pbind(\dur, 0.1, \midinote, Pbrown(-10, 12, 2, inf) + 50 + Prand([0, [0, 2]] * 2, inf), \amp, 2).play;

Pbind(\dur, 0.1, \midinote, Pbrown(-10, 12, 2, inf) + 50 + Prand([0, [0, 2]] * 2, inf), \amp, 3).play;


Pbind(\dur, Prand([0.1, 0.2], inf), \degree, Pbrown([0, 1, 2, 3, 1, 2, 0, 4], inf), \amp, 2).play;


//:
Scale.hijaz;


Scale

LorenzL.ar(
)