-module(lib_misc).
-export([for/3, qsort/1, test/0, pythag/1]).


test() ->
    [1,2,3,4,5] = qsort([3,2,1,4,5]),
    [2,2,2] = qsort([2,2,2]),
    [2] = qsort([2]),
    [{3,4,5}, {4,3,5}] = pythag(16),
    test_worked.



for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I)|for(I+1, Max, F)].

qsort([]) ->[];
qsort([Pivot|T]) -> 
    qsort([X || X <- T, X < Pivot])
    ++ [Pivot] ++
    qsort([X || X <- T, X >= Pivot]).


pythag(N) ->
    [ {A, B, C} ||
        A <- lists:seq(1, N),
        B <- lists:seq(1, N),
        C <- lists:seq(1, N),
        A+B+C =< N,
        A*A+B*B =:= C*C 
    ].