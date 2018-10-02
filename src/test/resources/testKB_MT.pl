:- dynamic test/1, test/2.

test(X,N) :- between(1,X,N).
	
test(EndNo,Sleep,N) :- between(1,EndNo,N), sleep(Sleep).

test(Id,EndNo,Sleep,N) :- 
	format(string(Text), "--------------------------> I have started the query test/4 for id ~d", [Id]),
	writeln(Text), !,
	test(EndNo,Sleep,N).

%% Check what can you do from Prolog to call Java: http://www.swi-prolog.org/pldoc/man?section=jpl
print_integer(JRef, X2) :-
%    jpl_get(JRef, intValue, X),         % this if it is accessing a field
    jpl_call(JRef, intValue, [], X),    % X should be the int value of object Integer JRef
    jpl_ref_to_type(JRef, T),           % T should be class([java,lang],[Integer])
    jpl_type_to_classname(T, ClassName),    % ClassName should be java.lang.Integer
    X2 is X+1,
    format(string(Text), "MESSAGE FROM PROLOG: The integer value of JAVA object (~s) is ~d", [ClassName, X2]),
    writeln(Text).	



bad(X) :-
	data(X),
	no_clause(X).
