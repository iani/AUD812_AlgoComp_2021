//: 20 Dec 2020 23:24
/*
Testing own implementation: Pser1
*/
//:Pser1
Pser2((1..5), 20).test;
//:Pser1 reverse
Pser2((1..5), 20, 4, -1).test;
//:Pser1 reverse - with shortcut
Pser2((1..5), 20).reverse.test;