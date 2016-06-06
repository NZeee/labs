-module(lab06).
-export([new/0, put/3, delete/2, find/2, get/2]).

new()->[].

put(K,V,DB) -> lists:keystore(K, 1, DB, {K, V}).

delete(K,DB) -> lists:keydelete(K, 1, DB).

get(K,DB) -> getValue(lists:keysearch(K, 1, DB)).

getValue({_,{_,V}}) -> V;
getValue(_) -> {error, not_exists}.

find(V,DB) ->  findeResult(lists:filter(fun ({_,V1}) -> V1 == V end, DB)).
findeResult([]) -> {error, not_found};
findeResult(L) -> [K || {K,_} <- L].