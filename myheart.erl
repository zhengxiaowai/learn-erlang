-module(myheart).
-compile(export_all).


heartbeat() ->
    io:format("i am runing~n"),
    timer:sleep(1000),
    heartbeat().

register_process(Fun) ->
    spawn(Fun).


exit_helper(Pid) ->
    exit(Pid, crash).

process_supervisor(Fun) ->
    Pid = register_process(Fun),
    spawn(fun() ->
            Ref = monitor(process, Pid),
            receive
                {'DOWN', Ref, process, Pid, _} ->
                    io:format("~p had crash, now restart......~n", [Pid]),
                    process_supervisor(Fun)
            end  
        end),
    Pid.