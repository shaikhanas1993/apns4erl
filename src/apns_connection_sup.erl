%%% @doc apns4erl connection's supervisor.
%%%
%%% Copyright 2017 Inaka &lt;hello@inaka.net&gt;
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%     http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%% @end
%%% @copyright Inaka <hello@inaka.net>
%%%
-module(apns_connection_sup).
-author("Felipe Ripoll <felipe@inakanetworks.com>").
-behaviour(supervisor).

%% API
-export([ start_link/1
        ]).

%% Supervisor callbacks
-export([ init/1
        ]).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec start_link(apns_connection:connection()) ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}.
start_link(Connection) ->
  supervisor:start_link(?MODULE, Connection).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

-spec init(any()) ->
  {ok, {supervisor:sup_flags(), [supervisor:child_spec()]}}.
init(Connection) ->
  SupFlags = #{ strategy  => one_for_one
              , intensity => 1000
              , period    => 3600
              },

  Child = #{ id       => apns_connection
           , start    => {apns_connection, start_link, [Connection]}
           , restart  => permanent
           , shutdown => 5000
           , type     => worker
           , modules  => [apns_connection]
           },

  {ok, {SupFlags, [Child]}}.
