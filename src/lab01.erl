-module(lab01).
-export([hi/0, fact/1, fib/1, contains/2, cost/1]).

hi() -> io:format("Hello!").

% факториал числа n
fact(0) -> 1;
fact(N) -> N*fact(N-1).

% n-ое число Фибоначчи
fib(0) -> 0;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

%true, если список L содержит E, false иначе
contains([],_) -> false;
contains([H|_],H) -> true;
contains([_|T],E) -> contains(T,E).	

price(apple)	-> 100;
price(pear)		-> 150;
price(milk)		-> 70;
price(beef)		-> 400;
price(pork)		-> 300.

% [{apple, Count}, ...]
% сумма по списку
cost([]) -> 0;
cost([{S,C}|T]) -> price(S)*C + cost(T).
