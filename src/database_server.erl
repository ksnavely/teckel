%%%%                                                                            
% database_server                                                                  
%                                                                               
% This module implements an OTP gen-server application which provides an abstracted
% interface for interacting with a database backend. This way we can change database
% backends later if so desired, and in general the rest of teckel doesn't need to
% know what kind of database layer we are using.
%                                                                               
% The server process can do N things:                                         
%   - Handle a new client with a create_client tagged call.                     
%   - Recieve and redistribute a chat message from a user with a chat tagged    
%     cast.                                                                     
%%%%                                                                            
                                                                                
-module(database_server).                                                          
                                                                                
-export([start/0]).                                                             
-export([handle_call/3, init/1]).                                
                                                                                
-behavior(gen_server). 

%% Module API

start() ->                                                                      
  % - Creates a cherl_server OTP application process                            
  {ok, Pid} = gen_server:start(?MODULE, [], []),                                
  register(database_server, Pid),                                                  
  io:format("[INFO] database_server has been started with pid: ~s.~n", [pid_to_list(Pid)]),
  {ok, Pid}. 

%% Server OTP callbacks below                                                      

handle_call({new_score, Username, Score}, _From, RedisPid) ->
  {ok, <<"OK">>} = eredis:q(RedisPid, ["SET", Username, Score]),
  {reply, ok, RedisPid}.
                                                                                   
init(_Args) ->                                                                     
  % Prepare the database for usage.
  {ok, RedisPid} = eredis:start_link(),
  {ok, RedisPid}.                         
