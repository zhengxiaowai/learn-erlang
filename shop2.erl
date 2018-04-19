-module(shop2).
-export([total/1]).
-import(lists, [map/2, sum/1]).

total(L) ->
    sum([shop:cost(A) * B || {A, B} <- L]).
    % sum(map(fun({What, N}) -> shop:cost(What) * N end, L)).