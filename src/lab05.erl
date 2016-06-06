-module(lab05).
-export([new/0, put/3, delete/2, find/2, get/2]).

new()->[].

put(K,V,[]) -> [{K,V}];
put(K,V,DB) -> [{K,V}|delete(K,DB)].

delete(K,DB) -> [{K1,V1} || {K1,V1} <- DB, K=/=K1].

get(K,DB) -> getValue([{K1,V1} || {K1,V1} <- DB, K==K1]).

getValue([]) -> {error, not_exists};
getValue([{_,V}|_]) -> V.

find(V,DB) -> findResult([{K1,V1} || {K1,V1} <- DB, V==V1]).
findResult([]) -> {error, not_found};
findResult(L) -> [K || {K,_} <- L].