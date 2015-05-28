-module(teckel_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Children = [{                                                                  
		database_server,              % Id                                            
		{database_server, start, []}, % {Module, Function, Arguments}                 
		temporary,                 % RestartStrategy                               
		brutal_kill,               % ShutdownStrategy                              
		worker,                    % worker or supervisor                          
		[database_server]             % ModuleList which implements the process       
	}],                                                                            
	% {ok, {{RestartStrategy, AllowedRestarts, MaxSeconds}, ChildSpecificationList}}
	{ok, {{one_for_one, 5, 10}, Children}}.
