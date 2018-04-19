-module(mylists).
-export([sum/1, map/2, test/0]).


test() ->
    L = [1,2,3,4,5],
    [2,4,6,8,10] = map(fun(X) -> 2*X end, L),
    [1,4,9,16,25] = map(fun(X) -> X*X end, L),
    test_worked.

sum([H|T]) -> H + sum(T);
sum([]) -> 0.

map(_, []) -> [];
map(F, [H|T]) -> [F(H)|map(F, T)].
