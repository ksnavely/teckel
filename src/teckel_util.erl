%% LIFTED FROM COUCHDB INSERT LICENCSE DUDE
%% https://github.com/apache/couchdb-couch/blob/master/src/couch_util.erl
-module(teckel_util).

-export([get_value/2, get_value/3, list_to_tuples/1]).

get_value(Key, List) ->
    get_value(Key, List, undefined).

get_value(Key, List, Default) ->
    case lists:keysearch(Key, 1, List) of
    {value, {Key,Value}} ->
        Value;
    false ->
        Default
    end.

list_to_tuples([]) ->
    [];

list_to_tuples(List) ->
    [K, V | T] = List,
    [{K, V} | list_to_tuples(T)].
