%% LIFTED FROM COUCHDB INSERT LICENCSE DUDE
%% https://github.com/apache/couchdb-couch/blob/master/src/couch_util.erl
-module(teckel_util).

-export([get_value/2, get_value/3]).

get_value(Key, List) ->
    get_value(Key, List, undefined).

get_value(Key, List, Default) ->
    case lists:keysearch(Key, 1, List) of
    {value, {Key,Value}} ->
        Value;
    false ->
        Default
    end.
