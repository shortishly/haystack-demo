%% Copyright (c) 2016 Peter Morgan <peter.james.morgan@gmail.com>
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(haystack_demo_config).
-export([acceptors/1]).
-export([port/1]).

port(http) ->
    envy(to_integer, http_port, 80).

acceptors(http) ->
    envy(to_integer, http_acceptors, 100).

envy(To, Name, Default) ->
    envy:To(haystack_demo, Name, default(Default)).

default(Default) ->
    [os_env, app_env, {default, Default}].
