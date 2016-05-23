-module(teckel_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  %% {HostMatch, list({PathMatch, Handler, Opts})}
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", root_handler, []},
      {"/user/:username/score", score_handler, []},
      {"/top_scores", ranking_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_http(my_http_listener, 100, [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  teckel_sup:start_link().

stop(_State) ->
    ok.
