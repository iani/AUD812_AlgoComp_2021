(
d = Dictionary.new;
d.add (\ceramic ->
PathName("/Users/nikos/Desktop/Material/Ceramic/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\food ->
	PathName("/Users/nikos/Desktop/Material/Food/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\hihat ->
	PathName("/Users/nikos/Desktop/Material/HiHat/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\kick ->
	PathName("/Users/nikos/Desktop/Material/Kick/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\mainkick ->
	PathName("/Users/nikos/Desktop/Material/mainkick/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\kitchenap ->
	PathName("/Users/nikos/Desktop/Material/Kitchen Appliances/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\kitchenut ->
	PathName("/Users/nikos/Desktop/Material/Kitchen Utensils/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\metal ->
	PathName("/Users/nikos/Desktop/Material/Metal/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\plastic ->
	PathName("/Users/nikos/Desktop/Material/Plastic/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\snare ->
	PathName("/Users/nikos/Desktop/Material/Snare/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\water ->
	PathName("/Users/nikos/Desktop/Material/Water/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\wood ->
	PathName("/Users/nikos/Desktop/Material/Wood/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\long->
	PathName("/Users/nikos/Desktop/Material/Long sounds/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\tampouraki->
	PathName("/Users/nikos/Desktop/Material/tampouraki/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\tonal->
	PathName("/Users/nikos/Desktop/Material/Tonal/").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
)