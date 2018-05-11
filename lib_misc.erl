-module(lib_misc).
% -export([
%          for/3,
%          qsort/1,
%          test/0,
%          pythag/1,
%          my_tuple_to_list/1,
%          my_date_string/0,
%          my_time_func/1,
%          on_exit/2,
% 		 my_spawn/3]).

-compile(export_all).

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

% my_tuple_to_list(T) -> my_tuple_to_list(T, 1, size(T)).
% my_tuple_to_list(T, Pos, Size) when Pos =< Size -> 
%     [element(Pos, T) | my_tuple_to_list(T, Pos + 1, Size)];
% my_tuple_to_list(_, _, _) -> [].

my_tuple_to_list(T) -> [element(I, T) || I <- lists:seq(1, size(T))].

my_time_func(F) ->
    Before= erlang:timestamp(),
    F(),
    After = erlang:timestamp(),
    io:format("runtime: ~f sec~n", [timer:now_diff(After, Before) / 1000]).

my_date_string() -> 
    {{Year, Month, Day}, {Hour, Minute, Second}} = calendar:now_to_local_time(erlang:timestamp()),
    io:format("~w-~w-~w ~w:~w:~w~n", [Year, Month, Day, Hour, Minute, Second]).


on_exit(Pid, Fun) -> 
    spawn(fun() -> 
                Ref = monitor(process, Pid),
                receive
                    {'DOWN', Ref, process, Pid, Why} ->
                        Fun(Why)
                end
        end).

test_func() -> 
    receive
        Any -> list_to_atom(Any)
    end.

my_spawn(Mod, Func, Args) ->
	Pid = spawn(Mod, Func, Args),
    {Hour1, Minute1, Second1} = time(),
	on_exit(Pid, fun(Why) -> 
            {Hour2, Minute2, Second2} = time(),
            io:format("Down ~p~n", [Why]),
            io:format("time:~p~n", [(Hour2-Hour1)*60*60 + (Minute2-Minute1)*60 + (Second2-Second1)])
        end),
    Pid.

my_spawn(Mod, Func, Args, Time) ->
    Pid = spawn_link(Mod, Func, Args),
    timeout_on_exit(Pid, Time),
    Pid.


timeout_on_exit(Pid, Time) ->
    spawn(fun() ->
        Ref = monitor(process, Pid),
        receive
            {'DOWN', Ref, process, Pid, Why} ->
                io:format("Down ~p~n", [Why])
        after Time ->
            exit(Pid, timeout)
        end
    end).