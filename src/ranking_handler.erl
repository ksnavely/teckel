% ranking_handler.erl
%
% This module processes a request for the top scores.
-module(ranking_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

init(_, Req, _Opts) ->
    {ok, Req, #state{}}.

handle(Req, State=#state{}) ->
    {Method, Req2} = cowboy_req:method(Req),
    {ok, FinalReq} = case Method of
        <<"GET">> ->
            Scores = gen_server:call(database_server, top_scores),
            ScoresJSON = jiffy:encode({Scores}),
            cowboy_req:reply(
                200,
                [{<<"content-type">>, <<"application/json">>}],
                io_lib:format("{\"top_scores\": ~s}", [ScoresJSON]),
                Req2);
        _ ->
            io_lib:format("score_hanlder: Invalid HTTP Method ~s", [Method]),
            cowboy_req:reply(
                409,
                [{<<"content-type">>, <<"application/json">>}],
                "{\"error\": \"This endpoint accepts only GET requests.\"}",
                Req2)
    end,
  {ok, FinalReq, State}.

terminate(_Reason, _Req, _State) ->
    ok.
