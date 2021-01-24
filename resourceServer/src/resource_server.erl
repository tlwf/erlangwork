-module(resource_server).
-behaviour(gen_server).
-export([acquire/3,release/2,shutdown/1,start_link/0]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%%-compile(export_all).
-define(RESOURCE, 1000).
-record(state, {resource,
  refs}).

start_link() -> gen_server:start_link(?MODULE, [], []).

acquire(Pid,N,Time) ->
  Ref = erlang:make_ref(),
  gen_server:call(Pid,{acquire,Ref,N,Time}).

release(Pid,Ref) ->
  gen_server:cast(Pid,{release,Ref}).

shutdown(Pid) ->
  gen_server:call(Pid, terminate).

init([]) -> {ok, #state{resource=?RESOURCE,
  refs=dict:new()}}.

handle_call({acquire,Ref,N,Time}, From, State) ->
  if State#state.resource >= N ->
    io:format("Available resource:~p~n",[State#state.resource]),
    NewRefs = dict:store(Ref, N, State#state.refs),
    NewResource = State#state.resource-N,
    io:format("The rest:~p~n",[NewResource]),
    erlang:send_after(Time*1000,self(),{timeout_release,Ref}),
    {reply,{acquire_success,Ref},State#state{resource=NewResource,refs=NewRefs}};
    true ->
      {reply,fail,State}
  end;
handle_call(terminate, _From, State) ->
  {stop, normal, ok, State}.
handle_cast({release,Ref}, State) ->
  case dict:find(Ref, State#state.refs) of
    {ok, E} ->
      NewRefs = dict:erase(Ref,State#state.refs),
      NewResource = State#state.resource + E,
      io:format("The rest:~p~n",[NewResource]),
      {noreply,State#state{resource=NewResource,refs=NewRefs}};
    error ->
      {noreply,State}
  end.

handle_info({timeout_release,Ref}, State) ->
  case dict:find(Ref, State#state.refs) of
    {ok, E} ->
      NewRefs = dict:erase(Ref,State#state.refs),
      NewResource = State#state.resource + E,
      io:format("Timeout_release, the rest:~p~n",[NewResource]),
      {noreply,State#state{resource=NewResource,refs=NewRefs}};
    error ->
      {noreply,State}
  end;
handle_info(Msg, State) ->
  io:format("Unexpected message: ~p~n",[Msg]),
  {noreply, State}.

terminate(Reason, State) ->
  io:format("Server was terminated.~p~n",[Reason]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.