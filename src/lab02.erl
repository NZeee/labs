-module(lab02).
-export([fact/1, fib/1, contains/2, cost/1]).

% факториал числа n
fact(N) -> 
	if 
		N == 0 -> 1;
		true -> N * fact(N-1)
	end.

% n-ое число Фибоначчи
fib(N) -> 
	if
		N == 0 -> 0;
		N == 1 -> 1;
		true -> fib(N-1) + fib(N-2)
	end.

%true, если список L содержит E, false иначе
contains(L,E) ->
	case L of
		[] -> false;
		[H|_] when H == E -> true;
		[_|T] -> contains(T,E)
	end.

price(Item) ->
	case Item of
		apple	-> 100;
		pear	-> 150;
		milk	-> 70;
		beef	-> 400;
		pork	-> 300
	end.

% [{apple, Count}, ...]
% сумма по списку
cost(L) ->
	case L of
		[] -> 0;
		[{S,C}|T] -> price(S)*C + cost(T)
	end.
