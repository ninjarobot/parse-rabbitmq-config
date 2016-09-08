%%%-------------------------------------------------------------------
%%% @author davidcurylo
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Sep 2016 11:36 AM
%%%-------------------------------------------------------------------
-module(get_config).
-author("davidcurylo").

%% API
-export([get_watermark/0, get_watermark/1, get_watermark_from_config/1]).

get_watermark_from_config(ConfigFile) ->
  case file:consult(ConfigFile) of
    { ok, [[{rabbit,Settings}]] } ->
      case lists:keyfind(vm_memory_high_watermark, 1, Settings) of
        false -> % unable to find vm_memory_high_watermark tuple in list
          { watermark_not_set };
        { _, Hwm } ->
          { watermark, Hwm }
      end;
    { ok, _ } -> { config_not_found };
    { error, Reason } -> { error, Reason }
  end.

get_watermark(Config_file_source) ->
  io:format("Reaing watermark from config...~n"),
  case Config_file_source of
    Config_file_source when is_function(Config_file_source, 0) ->
      case get_watermark_from_config(Config_file_source()) of
        { watermark_not_set } ->
          io:format("VM memory watermark not set, default is 0.4 of system memory.~n");
        { watermark, Val } ->
          io:format("~p of system memory.~n", [Val] );
        { config_not_found } ->
          io:format("Configuration terms for rabbit not found.~n");
        { error, Reason } -> io:format("~s~n", [file:format_error(Reason) ])
      end;
    _ ->
      io:format("Need to pass a function returning a string~n")
  end.

get_config_file() ->
  HomeDir = os:getenv("HOME"),
  string:concat(HomeDir, "/Downloads/rabbitmq_server-3.3.0/etc/rabbitmq/rabbitmq.config").

get_watermark() ->
  get_watermark(fun get_config_file/0).