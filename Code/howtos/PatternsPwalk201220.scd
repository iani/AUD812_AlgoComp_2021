//: 20 Dec 2020 09:05
/* examples of different types of patterns

*/

//:Pwalk ================
/*
Advance through the elements of a sequence (list), skipping elements according to step. 
*/
//:Pwalk - positive steps
(0..5) do: { | i |
    postf("printing step: %\n", i);
    Pwalk((1..5), i).asStream.nextN(10).postln;
};
//:Pwalk - positive steps, negative direction
(0..5) do: { | i |
    postf("printing step: %\n", i);
    Pwalk((1..5), i, -1).asStream.nextN(10).postln;
};
//:Pwalk - negative steps
(-1..-5) do: { | i |
    postf("printing step: %\n", i);
    Pwalk((1..5), i).asStream.nextN(10).postln;
};
//:================================================================
//:Using Pwalk to play a Pseq in reverse order
/* 
This starts with the first element, then plays the rest 
in reverse order.  To omit the first element, one has to skip it 
with a next, then use the rest. 
Is there a way to improve this?
Perhaps write a new class that does the next on the stream
before returning it?
*/
Pwalk((1..5), 4, 1).asStream.nextN(10).postln;
//:================================================================
//:Psetpre
