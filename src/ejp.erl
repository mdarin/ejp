%%%%----------------------------------------------
%%% Module: ejp 
%%% Description: JSON Pointer defines a string syntax
%%%  for identifying a specific value within a JavaScript 
%%%  Object Notation (JSON) document. 
%%% Author:
%%% Autogen:
%%% wiki page -> [link to wiki or page name]
%%%%----------------------------------------------
-module(ejp).

-export([get/2, set/3]).
-export([get_test_model_json/0]).

%-define(TEST,1).
-ifdef(TEST).
-compile(export_all).
-endif.

%%
%% API для запросов на получение и модификацию данных(но не структуры)
%% JavaScript Object Notation (JSON) Pointer
%% https://tools.ietf.org/html/rfc6901
%% JSON Pointer for Erlang
%

% Внимание! Массивы индексируются с 0!

%%====================================================================
%% API
%%====================================================================

%exports
get("/", Json) ->
	Json;
get(<<"/">>, Json) ->
	Json;
get(Path, Json) ->
	get0(parse(Path), Json).

%exports
set("/", _Json, Value) ->
	Value;
set(<<"/">>, _Json, Value) ->
	Value;
set(Path, Json, Value) ->
	set0(parse(Path), Json, Value).


%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

% value getter 
get0([], Json) ->
	Json;
get0([Key|RestPath], [Rec|_]=Array) when is_list(Rec) ->
	Idx = binary_to_integer(Key),
	case Idx >= 0 andalso Idx < length(Array) of
		true ->
			get0(RestPath, lists:nth(Idx+1, Array));
		_ ->
			throw({error, invalid_array_index})
	end;
get0([Key|RestPath], Props) ->
	case lists:keysearch(Key, 1, Props) of
		{value, {Key, Value}} ->
			get0(RestPath, Value);
		false ->
			throw({error, missing_path})
	end;
get0(_Path, _Json) ->
	throw({error, missing_path}).


% value setter
set0([]=_Path, _Json, Value) ->
	Value;
set0([Key|RestPath], [Rec|_]=Array, Value) when is_list(Rec) ->
	Idx = list_to_integer(binary_to_list(Key)),
	case Idx >= 0 andalso Idx < length(Array) of
  	true ->
			set_pos(RestPath, Array, Value, Idx, []);
  	_ ->
    	throw({error, invalid_array_index})
	end;
set0(Path, Props, Value) ->
	set_prop(Path, Props, Value, []);
set0(_Path, _Json, _Value) ->
	throw({error, missing_path}).


set_prop(_, [], _, _) ->
	throw({error, missing_path});
set_prop([Key | RestPath], [{Key, SubVal} | RestProps], Value, Acc) ->
	lists:reverse([{Key, set0(RestPath, SubVal, Value)} | Acc], RestProps);
set_prop(Path, [KV | RestProps], Value, Acc) ->
	set_prop(Path, RestProps, Value, [KV | Acc]).


set_pos(Path, [Val | RestVals], Value, 0, Acc) ->
	lists:reverse([set0(Path, Val, Value) | Acc], RestVals);
set_pos(Path, [Val | RestVals], Value, Idx, Acc) when Idx > 0 ->
	set_pos(Path, RestVals, Value, Idx-1, [Val | Acc]).


% path parser
parse(Path) when is_list(Path) ->
	parse(list_to_binary(Path), []);
parse(Path) when is_binary(Path) ->
	parse(Path, []).


parse(<<>>, []) ->
	throw({error, empty_path});
parse(<<>>, [[] | _]) ->
	throw({error, trailing_slash});
parse(<<>>, [Last | Acc]) ->
	Finished = lists:reverse(Last),    
	lists:map(fun list_to_binary/1, lists:reverse([Finished | Acc]));
parse(<<"/", Rest/binary>>, []) ->
	parse(Rest, [[]]);
parse(_, []) ->
	throw({error, invalid_path_start});
parse(<<"/", _Rest/binary>>, [[] | _]) ->
	throw({error, empty_path_component});
parse(<<"/", Rest/binary>>, [Acc | RestAcc]) ->
	parse(Rest, [[], lists:reverse(Acc) | RestAcc]);
parse(<<"%", H, L, Rest/binary>>, [Acc | RestAcc]) ->
	parse(Rest, [[dehex(H, L) | Acc] | RestAcc]);
parse(<<Val, Rest/binary>>, [Acc | RestAcc]) ->
 	parse(Rest, [[Val | Acc] | RestAcc]).


dehex(H, L) ->
	(hexval(H) bsl 4) + hexval(L).

hexval(B) when (B >= 65 andalso B =< 70) ->
	B - 65 + 10;
hexval(B) when (B >= 97 andalso B =< 102) ->
	B - 97 + 10;
hexval(B) when (B >= 48 andalso B =< 57) ->
	B - 48.




% тестовая структура
get_test_model_json() ->
	[{<<"empty">>,[[],[]]},
	{<<"k">>,
	 [[{<<"m1">>,[]},{<<"n1">>,[]}],[{<<"m2">>,[]},{<<"n2">>,[]}]]},
	{<<"a">>,
	 [[{<<"b1">>,<<"c1">>},
		 {<<"x">>,<<"x1">>},
		 {<<"y">>,<<"y1">>},
		 {<<"z">>,<<"z1">>},
		 {<<"s1">>,[[{<<"l1_1">>,<<"L1">>}],[{<<"l1_2">>,<<"L2">>}]]}],
		[{<<"b2">>,<<"c2">>},
		 {<<"x">>,<<"x2">>},
		 {<<"y">>,<<"y2">>},
		 {<<"z">>,<<"z2">>},
		 {<<"s2">>,[<<"foo">>,<<"bar">>,<<"baz">>]}]]},
	{<<"e">>,
	 [[<<"f">>,<<"g">>,<<"h">>],
		[],
		[<<"o">>,<<"p">>,<<"r">>,<<"t">>]]}].


