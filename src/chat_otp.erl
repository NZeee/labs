-module(chat_otp).
-export([start/0, new_user/1, server_loop/1, client_loop/1]).
-export([connect/1, disconnect/1, send/2, list/0]).

%% Start chat
start()->
    case whereis(chat_server) of
        undefined ->
            Pid = spawn(chat_otp, server_loop, [[]]),
            register(chat_server, Pid),
            {ok, Pid};
        _ ->
            {ok, whereis(chat_server)}
    end.

%% Create new user
new_user(User)->
    spawn(chat_otp, client_loop, [User]).

%% Start server process
server_loop(Pids)-> 
    receive
          {connect, Pid, User} ->
              io:format("! ~p connected to chat.~n", [User]),
              server_loop([Pid|Pids]);
          {disconnect, Pid, User} -> 
              io:format("! ~p disconnected from chat.~n", [User]),
              server_loop([X || X <- Pids, X =/= Pid]);
          {send, Pid, User, Message} ->
              io:format("! New message from ~p: ~p.~n", [User, Message]),
              broadcast([X || X <- Pids, X =/= Pid]), 
              server_loop(Pids);
          {list} ->
              io:format("! Chat users:~n"), 
              lists:foreach(fun(UserPid) -> UserPid ! {print} end, Pids),
              server_loop(Pids)
    end.
 
 %% Start user process
 client_loop(User)->
     Pid = self(),
     receive
         {connect} -> 
              chat_server ! {connect, Pid, User},
              client_loop(User);
         {disconnect} ->
              chat_server ! {disconnect, Pid, User};
         {send, Message} ->
              chat_server ! {send,  Pid, User, Message},
              client_loop(User);
         {print} ->
              io:format("~p~n", [User]),
              client_loop(User);
         {listen} ->
              io:format("(~p has read the message)~n", [User]),
              client_loop(User)
     end.

%%%---------------
%%% CHAT FUNCTIONS
%%%---------------
    
 %% Connect user to chat
 connect(UserPid) -> 
     UserPid ! {connect}.
 
 %% Disconnect user from chat
 disconnect(UserPid) ->
     UserPid ! {disconnect}.
 
 %% Send user message to chat
 send(UserPid, Message) ->
     UserPid ! {send, Message}.

%% Print chat users
list() ->
    chat_server ! {list}.

%%%------------------
%%% PRIVATE FUNCTIONS
%%%------------------

%% Broadcast new message to all chatmates
broadcast([])-> {ok, completed};
broadcast([H|T]) ->
    H ! {listen},
    broadcast(T).