// 23 Dec 2020 18:58
//:
/*
Window() == Window.new()
*/

(
var myfunction;
myfunction = { | number = 2 |
	postf(
		"The square of the number % is: %\n",
		number, number.squared
	);
};

myfunction.value(3);

myfunction.(4);
)
