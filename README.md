# ejp
JSON Pointer for Erlang

Based on the [Project](https://github.com/janl/erl-jsonpointer)

This is an implementation of [JSON Pointer](https://tools.ietf.org/html/rfc6901)

```bash
$ ./rebar compile
```

```bash
$ ./rebar eunit
```

```bash
$ erl
```

```erlang
1> code:add_path("/home/user/src/ejp/ebin").
true
2> ejp:get_test_model_json().
[{<<"empty">>,[[],[]]},
 {<<"k">>,
  [[{<<"m1">>,[]},{<<"n1">>,[]}],
   [{<<"m2">>,[]},{<<"n2">>,[]}]]},
 {<<"a">>,
  [[{<<"b1">>,<<"c1">>},
    {<<"x">>,<<"x1">>},
    {<<"y">>,<<"y1">>},
    {<<"z">>,<<"z1">>},
    {<<"s1">>,
     [[{<<"l1_1">>,<<"L1">>}],[{<<"l1_2">>,<<"L2">>}]]}],
   [{<<"b2">>,<<"c2">>},
    {<<"x">>,<<"x2">>},
    {<<"y">>,<<"y2">>},
    {<<"z">>,<<"z2">>},
    {<<"s2">>,[<<"foo">>,<<"bar">>,<<"baz">>]}]]},
 {<<"e">>,
  [[<<"f">>,<<"g">>,<<"h">>],
   [],
   [<<"o">>,<<"p">>,<<"r">>,<<"t">>]]}] 
3> ejp:get(<<"/k/0">>,ejp:get_test_model_json()).
[{<<"m1">>,[]},{<<"n1">>,[]}]
```
