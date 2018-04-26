-module(my_maps).
-export([loadconfig/1]).


loadconfig(Filename) -> 
    Content = file:read_file(Filename),
    io:format("~p", [Content]).
