

test(0).
test(2).
test(4).
test(6).
test(8).

test_plus(N, R) :- 
	number(N),
	test(N2), R is N2 + N.
	
	