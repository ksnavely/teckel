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
        {Json} = jiffy:decode(Body),
        User = teckel_util:get_value(<<"username">>, Json),
        Score = teckel_util:get_value(<<"score">>, Json),
        {ok, Req3} = cowboy_req:reply(200,
            [{<<"content-type">>, <<"text/plain">>}],
            io_lib:format("Nice high score ~s: ~s", [User, Score]),
            Req2),
	{ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
	ok.
