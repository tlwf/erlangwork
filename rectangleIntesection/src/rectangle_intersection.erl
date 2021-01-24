-module(rectangle_intersection).
-compile(export_all).
-export([]).

sortPoint(List) ->
  [A|Rest] = lists:sort(fun(A,B) ->
    AX = erlang:element(1,A), AY = erlang:element(2,A),
    BX = erlang:element(1,B), BY = erlang:element(2,B),
    if AX<BX ->
      true;
      AX =:= BX ->
        if AY<BY ->
          true;
          true ->
            false
        end;
      true ->
        false
    end end,List),
  [A|lists:last(Rest)].

main(ListA,ListB) ->
  [{AX1,AY1}|{AX2,AY2}] = sortPoint(ListA),
  [{BX1,BY1}|{BX2,BY2}] = sortPoint(ListB),
  if AX1<BX2 andalso AX2>BX1 andalso AY1<BY2 andalso AY2>BY1 ->
    true;
    true ->
      false
  end.