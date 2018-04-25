-module(math_functions).
-export([even/1, odd/1, filter/2, split1/1, split2/1, test/0]).


test() ->
    true = even(4),
    false = odd(4),
    [1, 5] = filter(fun(X) -> odd(X) end, [1,2,4,5,6]),
    {[1,5], [2,4,6]} = split1([1,2,4,5,6]),
    {[1,5], [2,4,6]} = split2([1,2,4,5,6]),
    test_worked.

even(N) -> N rem 2 =:= 0.
odd(N) -> not even(N).

filter(F, L) -> [ X || X <- L, F(X)].

split1(L) -> {filter(fun(X) -> odd(X) end, L), filter(fun(X) -> even(X) end, L)}. 
split2(L) -> odds_and_evens_acc(L, [], []).

 odds_and_evens_acc([H|T], Odds, Evens) ->
    case (H rem 2) of
        1 -> odds_and_evens_acc(T, [H|Odds], Evens);
        0 -> odds_and_evens_acc(T, Odds, [H|Evens])
    end;
odds_and_evens_acc([], Odds, Evens) -> 
    {lists:reverse(Odds), lists:reverse(Evens)}.