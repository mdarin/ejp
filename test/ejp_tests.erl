%%%%----------------------------------------------
%%% Module: ejp_tests
%%% Description: unit test
%%% Author:
%%% Autogen:
%%% wiki page -> [link to wiki or page name]
%%%%----------------------------------------------
-module(ejp_tests).
-include_lib("eunit/include/eunit.hrl").

% ?assertThrow(ModelThrow, Throw)
% ?assertEqual(ModelValue, Value),

getter_jsonptr_test() ->
	Model = ejp:get_test_model_json(),
	ModelValue0 = [
		[{<<"m1">>,[]},{<<"n1">>,[]}],
 		[{<<"m2">>,[]},{<<"n2">>,[]}]
	],
	ModelValue1 = [
		{<<"b1">>,<<"c1">>},
 		{<<"x">>,<<"x1">>},
 		{<<"y">>,<<"y1">>},
 		{<<"z">>,<<"z1">>},
 		{<<"s1">>,[
			[{<<"l1_1">>,<<"L1">>}],
			[{<<"l1_2">>,<<"L2">>}]
		]}
	],
	ModelValue2 = <<"L2">>, 
	ModelValue3 = [], 
	% контроль получаемых значений
	% в случае несовпадения правой и левой частей будет эксэпшн 
	% ** exception error: no match of right hand side value
	ModelValue0 = ejp:get(<<"/k">>,Model),
	ModelValue1 = ejp:get(<<"/a/000">>,Model),
	ModelValue2 = ejp:get(<<"/a/0/s1/001/l1_2">>,Model),
	ModelValue3 = ejp:get(<<"/empty/01">>,Model),
	ok.

setter_jsonptr_test() ->
	Model = ejp:get_test_model_json(),
	NewModelValue = [{<<"wer">>,<<"stain">>}],
	NewModel = [{<<"empty">>,[[],NewModelValue]},
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
		[<<"o">>,<<"p">>,<<"r">>,<<"t">>]]}],
	% контроль совпадения результата модификации данных
	% в случае несовпадения правой и левой частей будет эксэпшн 
	% ** exception error: no match of right hand side value
	NewModel = ejp:set("/empty/00000001", Model, NewModelValue),
	ok.

