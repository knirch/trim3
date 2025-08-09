-module(stomp).
-export([stomp_list/1,crlf/0]).

crlf() ->
    [13,10].

%% Stomp out one entry lists
%%  in: [[13, 10], [10], [13]]
%% out: [[13, 10], 10, 13]
stomp_list(L) ->
    [ case E of
          [H] -> H;
          _   -> E
      end || E <- L ].
