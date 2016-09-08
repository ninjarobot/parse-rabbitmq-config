%%%-------------------------------------------------------------------
%%% @author davidcurylo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2016 3:52 PM
%%%-------------------------------------------------------------------
-module(get_config_tests).
-author("davidcurylo").

-include_lib("eunit/include/eunit.hrl").

get_vm_watermark_present_test() ->
  HomeDir = os:getenv("HOME"),
  ConfigFile = string:concat(HomeDir, "/Downloads/rabbitmq_server-3.3.0/etc/rabbitmq/rabbitmq.config"),
  case get_config:get_watermark_from_config(ConfigFile) of
    { watermark, Val } -> ?assertEqual(0.4, Val);
    _ -> ?assert(false)
  end.