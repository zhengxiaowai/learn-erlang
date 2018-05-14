-module(kvs).
-compile(export_all).

start() -> register(kvs, spawn(fun() -> loop() end)).

store(Key, Value) -> rpc({store, Key, Value}).

lookup(Key) -> rpc({lookup, Key}). 

rpc(Q) -> 
    kvs ! {self(), Q},
    receive 
        {kvs, Replay} ->
            Replay
    end.


loop() ->
    receive 
        {From, {store, Key, Value}} ->
            put(Key, {Key, Value}),
            From ! {kvs, true},
            loop();
        
        {From, {lookup, Key}} ->
            From ! {kvs, get(Key)},
            loop()
    end.
