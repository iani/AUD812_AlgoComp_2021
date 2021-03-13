// 26 Nov 2020 14:12
// «Blue Crackle» by alln4tural on 21 Jun'12 10:26 in sctweet
// from: http://sccode.org/1-4Qr

//y.stop;y.free;y=
fork{
	loop{
		play{
			Splay.ar(
				{Formlet.ar(
					Crackle.ar(2,0.03),
					73.rand.midicps,
					0.0005)
					*EnvGen.kr(Env.perc,1,1,0,9,2)
				}!5) * 0.3
		};
		9.rand.wait;
	}
};// #sctweet #blueCrackle