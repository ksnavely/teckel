-module(teckel).

-export([start/0, get_config/1]).

start() ->
    application:ensure_all_started(teckel).

get_config(Key) ->
    application:get_env(teckel, Key).
