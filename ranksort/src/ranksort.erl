-module(ranksort).
-export([]).
-compile(export_all).

-define(LEN, 10).
-define(MAXLEVEL, 100).
-define(FNAME, {"Jacob", "Matthew", "Tyler", "Daniel", "Austin", "Ashley", "Lauren", "Nicole", "Grace", "Natalie"}).
-define(LNAME, {"Adams", "Bell", "Carter", "David", "Edward", "Evelyn", "Green", "Hall", "Lee", "Oliver"}).

generatePlayers(N) when is_integer(N) -> generatePlayers(N,[]).
generatePlayers(0,Acc) -> Acc;
generatePlayers(N,Acc) ->
  generatePlayers(N-1,[{erlang:element(rand:uniform(?LEN),?FNAME) ++ " " ++
    erlang:element(rand:uniform(?LEN),?LNAME),rand:uniform(?MAXLEVEL)}|Acc]).

generateRank(List,N) -> generateRank(List,N,1).
generateRank([Player|List],N,Rank) when N>0 ->
  io:format("~p ~p~n",[Rank,Player]),
  generateRank(List,N-1,Rank+1);
generateRank(_,_,_) -> ok.

main(PlayerNum,RankNum) ->
  io:format("There are ~p players:~n",[PlayerNum]),
  Players = generatePlayers(PlayerNum),
  lists:foreach(fun(Arg) -> io:format("~p~n",[Arg]) end,Players),
  SortedPlayers = lists:sort(fun(A,B) -> X = erlang:element(2,A), Y= erlang:element(2,B),
    if X<Y -> false; true -> true end end,Players),
  io:format("The first ~p high-level players:~n",[RankNum]),
  generateRank(SortedPlayers,RankNum).

