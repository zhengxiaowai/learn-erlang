-module(test3).
-export([f1/0]).

f1() ->
    tuple_to_list(list_to_tuple({1,2,3})).