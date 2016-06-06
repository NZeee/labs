-module(chat).
-export([start/0, loop/1]).
-export([connect/2, disconnect/2, send/3, list/1]).

%% Start chat
start()->
    spawn(chat,loop,[[]]).

%% Start process
loop(Users)-> 
    receive
          {connect, User} ->
               io:format("! ~p connected to chat.~n", [User]),
               loop([User|Users]);
          {disconnect, User} -> 
              io:format("! ~p disconnected from chat.~n", [User]),
              loop([X || X <- Users, X =/= User]);
          {send, User, Message} -> 
              io:format("! Message for ~p: ~p.~n", [User, Message]), 
              loop(Users);
          {list} ->
              io:format("! Chat users:~n"), 
              lists:foreach(fun(X) -> io:format("~p~n", [X]) end, Users),
              loop(Users)
    end.
    
%%%---------------
%%% CHAT FUNCTIONS
%%%---------------

%% Connect user to chat
connect(User, Server) -> 
    Server ! {connect, User}.
     
%% Disconnect user from chat
disconnect(User, Server) ->
    Server ! {disconnect, User}.

%% Send message to user
send(Message,User,Server) ->
    Server ! {send, User, Message}.

%% Print chat users
list(Server) ->
    Server ! {list}.