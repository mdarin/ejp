# JSON Pointer for Erlang

## ejp

Based on the [Project](https://github.com/janl/erl-jsonpointer)

This is an implementation of [JSON Pointer](https://tools.ietf.org/html/rfc6901)

## Build
```bash
$ ./rebar compile
```

## Test

```bash
$ ./rebar eunit
```

## Run

```bash
$ erl
```
```
Erlang/OTP 21 [erts-10.3.5.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Eshell V10.3.5.1  (abort with ^G)
```

### Setup path to ebin directory before start

```erlang
1> pwd().
```
```
/home/user/src/ejp
ok
```
```erlang
2> code:add_path("/home/user/src/ejp/ebin").
```
```
true
```

### Start and stop the application stub(just for test)

```erlang
3> application:start(ejp).
```
```
ok
```
```erlang
4> application:stop(ejp).
```
```
=INFO REPORT==== 27-Jun-2019::10:38:43.877032 ===
    application: ejp
    exited: stopped
    type: temporary
ok
```
### Usage examples

```erlang
6> ejp:get_test_model_json().
```
```
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
```
```erlang
7> ejp:get("/k/1",ejp:get_test_model_json()).
```
```
[{<<"m2">>,[]},{<<"n2">>,[]}]
```
```erlang
8> ejp:get(<<"/a/0/s1/1/l1_2">>,ejp:get_test_model_json()).
```
```
<<"L2">>
```
```erlang
9> ejp:set("/e/1",ejp:get_test_model_json(),[<<"j">>,<<"k">>,<<"l">>]).
```
```
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
   [<<"j">>,<<"k">>,<<"l">>],
   [<<"o">>,<<"p">>,<<"r">>,<<"t">>]]}]
```
