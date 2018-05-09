-module(lib_misc).
-export([
         for/3,
         qsort/1,
         test/0,
         pythag/1,
         my_tuple_to_list/1,
         my_date_string/0,
         my_time_func/1,
         on_exit/2,
		 my_spawn/2,
		 my_spawn/3]).


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
                    {'Down', Ref, Pid, Why} ->
                        Fun(Why)
                end
        end).
		
		
my_spawn(Mod, Func, Args) ->
	Pid = spawn(Mod, Func, Args),
	statistics(runtime),
	on_exit(Pid, fun(Why) -> 
					{_, Runtime} = statistics(runtime),
					ExitisTime = Runtime / 1000,
					io:format("~p died with ~p, runtime= ~p mircoseconds~n", [Pid, Why, ExitisTime])
				end).
	

my_spawn(Func, Args) ->
	Pid = spawn(Func, Args),
	statistics(runtime),
	on_exit(Pid, fun(Why) -> 
					{_, Runtime} = statistics(runtime),
					ExitisTime = Runtime /1000,
					io:format("~p died with ~p, runtime= ~p mircoseconds~n", [Pid, Why, ExitisTime])
				end).