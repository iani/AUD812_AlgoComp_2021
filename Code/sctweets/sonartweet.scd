// 26 Nov 2020 14:09
// «Sonar tweet» by rogerpibernat on 11 Jun'12 18:29 in sctweettweet
// from http://sccode.org/1-4Qm
// Note: * 0.1 added by IZ

{inf.do{{GVerb.ar(RLPF.ar(RHPF.ar(WhiteNoise.ar(0.1),870),880,0.0068)*EnvGen.kr(Env.perc(0.01,4),doneAction:2),10,3,0.9) * 0.1}.play;5.wait}}.fork
