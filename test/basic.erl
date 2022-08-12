%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface §
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(basic).   
 
-export([start/0
	]).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),
    ok=create_test(),
    ok=log_test(),
    ok=read_test(),

%    init:stop(),
    ok.


setup_test()->
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
create_test()->
    os:cmd("rm -rf test_log_dir"),
    ok=file:make_dir("test_log_dir"),
    ok=file:make_dir("test_log_dir/logs"),
    LogFile1=filename:join(["test_log_dir","logs","test1.logs"]),
    ok=rpc:call(node(),application,start,[nodelog],5000),
    ok=rpc:call(node(),nodelog,create,[LogFile1],5000),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
log_test()->

    true=rpc:cast(node(),nodelog,log,[notice,?MODULE_STRING,?LINE,"notice1"]),
    true=rpc:cast(node(),nodelog,log,[warning,?MODULE_STRING,?LINE,"warning1"]),
    true=rpc:cast(node(),nodelog,log,[alert,?MODULE_STRING,?LINE,"alert1"]),

    Term={error,[eexists,{?MODULE,?FUNCTION_NAME}]},
    R= io_lib:format("~p",[Term]),
    TermAsStering=lists:flatten(R),
  
    true=rpc:cast(node(),nodelog,log,[alert,?MODULE_STRING,?LINE,TermAsStering]),
    true=rpc:cast(node(),nodelog,log,[alert,?MODULE_STRING,?LINE,"alert2"]),
    
       
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
read_test()->
    [{_,"basic",_,"\"notice1\""}]=rpc:call(node(),nodelog,read,[notice]),
    [{_,"basic",_,"\"warning1\""}]=rpc:call(node(),nodelog,read,[warning]),
    [{_,"basic",_,"\"alert2\""},
     {_,"basic",_,"\"{error,[eexists,{basic,log_test}]}\""}]=rpc:call(node(),nodelog,read,[alert]),
    ok.
    

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

stop_test()->
   % init:stop(),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
setup()->
    ok.
