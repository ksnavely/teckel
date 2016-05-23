% score_handler.erl
%
% This module processes a request for submitting/fetching a user's score.
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
    {ok, FinalReq} = case Method of
        <<"POST">> ->
            {Json} = jiffy:decode(Body),
            {Username, Req4} = cowboy_req:binding(username, Req3),
            Score = teckel_util:get_value(<<"score">>, Json),
            gen_server:call(database_server, {new_score, Username, Score}),
            cowboy_req:reply(
                200,
                [{<<"content-type">>, <<"application/json">>}],
                "{\"ok\": true}",
                Req4);
        <<"GET">> ->
            {Username, Req4} = cowboy_req:binding(username, Req3),
            Score = gen_server:call(database_server, {current_score, Username}),
            cowboy_req:reply(
                200,
                [{<<"content-type">>, <<"application/json">>}],
                io_lib:format("{\"score\": ~s}", [Score]),
                Req4);
        _ ->
            io_lib:format("score_hanlder: Invalid HTTP Method ~s", [Method]),
            cowboy_req:reply(
                409,
                [{<<"content-type">>, <<"application/json">>}],
                "{\"error\": \"This endpoint accepts only GET, POST requests.\"}",
                Req3)
    end,
  {ok, FinalReq, State}.

terminate(_Reason, _Req, _State) ->
    ok.
