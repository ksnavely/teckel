%%%%
% database_server
%
% This module implements an OTP gen-server application which provides an abstracted
% interface for interacting with a database backend. This way we can change database
% backends later if so desired, and in general the rest of teckel doesn't need to
% know what kind of database layer we are using.
%
%%%%

-module(database_server).

-export([start/0]).
-export([handle_call/3, init/1]).

-behavior(gen_server).

%% Module API

start() ->
    % - Creates a database_server OTP application process
    {ok, Pid} = gen_server:start(?MODULE, [], []),
    register(database_server, Pid),
    io:format("[INFO] database_server has been started with pid: ~s.~n", [pid_to_list(Pid)]),
    {ok, Pid}.

%% Server OTP callbacks below

handle_call({new_score, Username, Score}, _From, RedisPid) ->
    % Set the user's score in Redis.
    {ok, _} = eredis:q(RedisPid, ["ZADD", teckel:get_config(leaderboard), Score, Username]),
    {reply, ok, RedisPid};

handle_call({current_score, Username}, _From, RedisPid) ->
    io:format("username: ~s", [Username]),
    % Get the user's score in Redis, convert back to int
    {ok, Score} = eredis:q(RedisPid, ["ZSCORE", teckel:get_config(leaderboard), Username]),
    Score2 = case Score of
        undefined -> undefined;
        _         -> binary_to_list(Score)
    end,
    io:format("score: ~s", [Score2]),
    {reply, Score2, RedisPid};

handle_call(top_scores, _From, RedisPid) ->
    io:format("Handling top scores...~n", []),
    % Get the user's score in Redis, convert back to int
    {ok, Scores} = eredis:q(
        RedisPid,
        ["ZREVRANGE", teckel:get_config(leaderboard), 0, 10, "WITHSCORES"]
    ),
    Scores2 = case Scores of
        undefined -> undefined;
        _         -> teckel_util:list_to_tuples(Scores)
    end,
    {reply, Scores2, RedisPid}.

init(_Args) ->
    % Prepare the database for usage.
    {ok, RedisPid} = eredis:start_link(),
    {ok, RedisPid}.
