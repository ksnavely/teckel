-module(score_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

init(_, Req, _Opts) ->
	{ok, Req, #state{}}.

handle(Req, State=#state{}) ->
	{ok, Body, Req2} = cowboy_req:body(Req),
	{Method, Req3} = cowboy_req:method(Req2),
	{ok, Req4} = case Method of
		<<"POST">> ->
			{Json} = jiffy:decode(Body),
			Username = teckel_util:get_value(<<"username">>, Json),
			Score = teckel_util:get_value(<<"score">>, Json),
			gen_server:call(database_server, {new_score, Username, Score}),
			cowboy_req:reply(
				200,
				[{<<"content-type">>, <<"application/json">>}],
				"{\"ok\": true}",
				Req3);
		_ -> 
			io_lib:format("score_hanlder: Invalid HTTP Method ~s", [Method]),
			cowboy_req:reply(
				400,
				[{<<"content-type">>, <<"application/json">>}],
				"{\"error\": \"This endpoint accepts only POST requests.\"}",
				Req3)
    end,
  {ok, Req4, State}.

terminate(_Reason, _Req, _State) ->
	ok.
