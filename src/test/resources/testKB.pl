:- dynamic test/1, test/2.

test(80).
test(2).
test(4).
test(6).
test(8).

test_plus(N, R) :- 
	number(N),
	test(N2), R is N2 + N.
	
test_slow(X) :-
	test(X),
	sleep(0.1).

	
person(john, 20, melbourne).
person(maria, 31, city(sydney)).
person(maria, 11, city(perth)).
person(adam, 18, geelong).
person(michelle, 14, lorne).



% current_job(car, floor, direction)
current_job(0, 3, up).
current_job(1, 5, down).


data(27).
data(2.3333).
data(tea).
data("this is a native string").
data('this is quoted string').
data(mother(john,father(peter,mark),23.222)).
data([]).
data([1,2,3,4]).
data([peter, mother(maria), 34, [1,2,3,4]]).
data(_Variable).


data_string("string0").
data_string(atom0).

% integer, float, atom, compound, var, ok
data_all(23, 12.21, sebastian, mother(maria,father(john)), _X, [1,2,3,4], ok).
data_exp(X, Y, Z, Z is X+Y).
data_list([ok]).
data_list([[ok]]).

%% Check what can you do from Prolog to call Java: http://www.swi-prolog.org/pldoc/man?section=jpl
print_integer(JRef, X2) :-
%    jpl_get(JRef, intValue, X),         % this if it is accessing a field
    jpl_call(JRef, intValue, [], X),    % X should be the int value of object Integer JRef
    jpl_ref_to_type(JRef, T),           % T should be class([java,lang],[Integer])
    jpl_type_to_classname(T, ClassName),    % ClassName should be java.lang.Integer
    X2 is X+1,
    format(string(Text), "MESSAGE FROM PROLOG: The integer value of JAVA object (~s) is ~d", [ClassName, X2]),
    writeln(Text).	




