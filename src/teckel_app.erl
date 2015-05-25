-module(teckel_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
        Dispatch = cowboy_router:compile([
            {'_', [{"/", root_handler, []}]}
        ]),
        {ok, _} = cowboy:start_http(my_http_listener, 100, [{port, 8080}],
            [{env, [{dispatch, Dispatch}]}]
        ),
        teckel_sup:start_link().

stop(_State) ->
	ok.