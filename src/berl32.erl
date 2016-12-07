%%%-------------------------------------------------------------------
%%% Copyright (c) 2016, Mathieu Kerjouan <mke [at] steepath [dot] eu>
%%%
%%% Permission to  use, copy, modify, and/or  distribute this software
%%% for any  purpose with or  without fee is hereby  granted, provided
%%% that the above copyright notice  and this permission notice appear
%%% in all copies.
%%%
%%% THE  SOFTWARE IS  PROVIDED "AS  IS" AND  THE AUTHOR  DISCLAIMS ALL
%%% WARRANTIES  WITH REGARD  TO  THIS SOFTWARE  INCLUDING ALL  IMPLIED
%%% WARRANTIES OF MERCHANTABILITY  AND FITNESS. IN NO  EVENT SHALL THE
%%% AUTHOR   BE  LIABLE   FOR  ANY   SPECIAL,  DIRECT,   INDIRECT,  OR
%%% CONSEQUENTIAL  DAMAGES OR  ANY DAMAGES  WHATSOEVER RESULTING  FROM
%%% LOSS OF  USE, DATA OR PROFITS,  WHETHER IN AN ACTION  OF CONTRACT,
%%% NEGLIGENCE  OR  OTHER  TORTIOUS  ACTION,  ARISING  OUT  OF  OR  IN
%%% CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
%%%
%%%-------------------------------------------------------------------
%%%
%%% @author    Mathieu Kerjouan <mke [at] steepath [dot] eu>
%%% @copytight 2016 Mathieu Kerjouan
%%% @version   0.1
%%% @title     berl32, base32 crockford erlang implementation
%%%
%%% @doc you can find more documentation here:
%%%       - http://www.crockford.com/wrmg/base32.html     
%%%       - https://crockfordbase32.codeplex.com/
%%%       - https://github.com/jbittel/base32-crockford
%%% @end
%%%
%%% @todo - add type and specification
%%%       - add more unit test
%%%       - add checksum validation
%%%       - add benchmarking and profiling
%%%       - add more documentation
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(berl32).
-author('Mathieu Kerjouan').
-export([struct/0, struct/1]).
-export([check/0, check/1]).
-export([encode/1]).
-export([decode/1]).
-include_lib("eunit/include/eunit.hrl").

%%--------------------------------------------------------------------
%% 
%%--------------------------------------------------------------------
-type symbol() :: 0 .. 31.
-type decode_symbol() :: string().
-type decode_symbols() :: [ decode_symbol(), ... ].
-type encode_symbol() :: string().
-type symbols() :: { symbol(), decode_symbols(), encode_symbol() }.
-type check_symbols() :: symbols().

%%--------------------------------------------------------------------
%% @doc This function give you all encoded/decoded value in list of
%%      tuple. Note, this version give you only list() value and not
%%      bitstring.
%% @end
%%--------------------------------------------------------------------
-spec struct() -> [ symbols(), ... ].
struct() ->
    [{  0, ["0", "O", "o"], "0" } 
    ,{  1, ["1", "I", "i", "L", "l"], "1" } 
    ,{  2, ["2"], "2" }
    ,{  3, ["3"], "3" }
    ,{  4, ["4"], "4" }
    ,{  5, ["5"], "5" }
    ,{  6, ["6"], "6" }
    ,{  7, ["7"], "7" }
    ,{  8, ["8"], "8" }
    ,{  9, ["9"], "9" }
    ,{ 10, ["A", "a"], "A" }
    ,{ 11, ["B", "b"], "B" }
    ,{ 12, ["C", "c"], "C" }
    ,{ 13, ["D", "d"], "D" }
    ,{ 14, ["E", "e"], "E" }
    ,{ 15, ["F", "f"], "F" }
    ,{ 16, ["G", "g"], "G" }
    ,{ 17, ["H", "h"], "H" }
    ,{ 18, ["J", "j"], "J" }
    ,{ 19, ["K", "k"], "K" }
    ,{ 20, ["M", "m"], "M" }
    ,{ 21, ["N", "n"], "N" }
    ,{ 22, ["P", "p"], "P" }
    ,{ 23, ["Q", "q"], "Q" }
    ,{ 24, ["R", "r"], "R" }
    ,{ 25, ["S", "s"], "S" }
    ,{ 26, ["T", "t"], "T" }
    ,{ 27, ["V", "v"], "V" }
    ,{ 28, ["W", "w"], "W" }
    ,{ 29, ["X", "x"], "X" }
    ,{ 30, ["Y", "y"], "Y" }
    ,{ 31, ["Z", "z"], "Z" }
    ].

%%--------------------------------------------------------------------
%% @doc struct/1 convert raw integer() value to bitstring() encoded
%%      value and do reverse convertion, bitstring() encoded value to
%%      raw integer() value.
%% @end
%% --------------------------------------------------------------------
-spec struct(integer()) -> bitstring();
	    (bitstring()) -> integer().
struct(0) -> <<"0">>;
struct(1) -> <<"1">>;
struct(2) -> <<"2">>;
struct(3) -> <<"3">>;
struct(4) -> <<"4">>;
struct(5) -> <<"5">>;
struct(6) -> <<"6">>;
struct(7) -> <<"7">>;
struct(8) -> <<"8">>;
struct(9) -> <<"9">>;
struct(10) -> <<"A">>;
struct(11) -> <<"B">>;
struct(12) -> <<"C">>;
struct(13) -> <<"D">>;
struct(14) -> <<"E">>;
struct(15) -> <<"F">>;
struct(16) -> <<"G">>;
struct(17) -> <<"H">>;
struct(18) -> <<"J">>;
struct(19) -> <<"K">>;
struct(20) -> <<"M">>;
struct(21) -> <<"N">>;
struct(22) -> <<"P">>;
struct(23) -> <<"Q">>;
struct(24) -> <<"R">>;
struct(25) -> <<"S">>;
struct(26) -> <<"T">>;
struct(27) -> <<"V">>;
struct(28) -> <<"W">>;
struct(29) -> <<"X">>;
struct(30) -> <<"Y">>;
struct(31) -> <<"Z">>;
struct(<<"0">>) -> 0;
struct(<<"O">>) -> 0;
struct(<<"o">>) -> 0;
struct(<<"1">>) -> 1;
struct(<<"L">>) -> 1;
struct(<<"l">>) -> 1;
struct(<<"I">>) -> 1;
struct(<<"i">>) -> 1;
struct(<<"2">>) -> 2;
struct(<<"3">>) -> 3;
struct(<<"4">>) -> 4;
struct(<<"5">>) -> 5;
struct(<<"6">>) -> 6;
struct(<<"7">>) -> 7;
struct(<<"8">>) -> 8;
struct(<<"9">>) -> 9;
struct(<<"A">>) -> 10;
struct(<<"a">>) -> 10;
struct(<<"B">>) -> 11;
struct(<<"b">>) -> 11;
struct(<<"C">>) -> 12;
struct(<<"c">>) -> 12;
struct(<<"D">>) -> 13;
struct(<<"d">>) -> 13;
struct(<<"E">>) -> 14;
struct(<<"e">>) -> 14;
struct(<<"F">>) -> 15;
struct(<<"f">>) -> 15;
struct(<<"G">>) -> 16;
struct(<<"g">>) -> 16;
struct(<<"H">>) -> 17;
struct(<<"h">>) -> 17;
struct(<<"J">>) -> 18;
struct(<<"j">>) -> 18;
struct(<<"K">>) -> 19;
struct(<<"k">>) -> 19;
struct(<<"M">>) -> 20;
struct(<<"m">>) -> 20;
struct(<<"N">>) -> 21;
struct(<<"n">>) -> 21;
struct(<<"P">>) -> 22;
struct(<<"p">>) -> 22;
struct(<<"Q">>) -> 23;
struct(<<"q">>) -> 23;
struct(<<"R">>) -> 24;
struct(<<"r">>) -> 24;
struct(<<"S">>) -> 25;
struct(<<"s">>) -> 25;
struct(<<"T">>) -> 26;
struct(<<"t">>) -> 26;
struct(<<"V">>) -> 27;
struct(<<"v">>) -> 27;
struct(<<"W">>) -> 28;
struct(<<"w">>) -> 28;
struct(<<"X">>) -> 29;
struct(<<"x">>) -> 29;
struct(<<"Y">>) -> 30;
struct(<<"y">>) -> 30;
struct(<<"Z">>) -> 31;
struct(<<"z">>) -> 31.

%%--------------------------------------------------------------------
%% @doc check/0 give you all check characters used in base32.
%% @end
%%--------------------------------------------------------------------
-spec check() -> [check_symbols(), ...].
check() ->
    [{32, ["*"], "*"}
    ,{33, ["~"], "~"}
    ,{34, ["$"], "$"}
    ,{35, ["="], "="}
    ,{36, ["U", "u"], "U"}].

%%--------------------------------------------------------------------
%% @doc check/1 convert raw integer() value to bitstring() encoded 
%%      value and do also in reverse, bitstring() to integer().
%% @end
%%--------------------------------------------------------------------
-spec check(integer()) -> bitstring();
	   (bitstring()) -> integer().
check(32) -> <<"*">>;
check(33) -> <<"~">>;
check(34) -> <<"$">>;
check(35) -> <<"=">>;
check(36) -> <<"U">>;
check(<<"*">>) -> 32;
check(<<"~">>) -> 33;
check(<<"$">>) -> 34;
check(<<"=">>) -> 35;
check(<<"U">>) -> 36;
check(<<"u">>) -> 36.

%%--------------------------------------------------------------------
%% @doc encode/1 encode raw value to bitstring() encoded value.
%% @end
%%--------------------------------------------------------------------
% -spec encode(Data) -> ok.
encode(Data) ->
    bitstring_to_base32(Data).

bitstring_to_base32_test() ->
    ?assertEqual(bitstring_to_base32(<<1>>), {ok, <<"1">>}),
    ?assertEqual(bitstring_to_base32(<<2>>), {ok, <<"2">>}),
    ?assertEqual(bitstring_to_base32(<<3>>), {ok, <<"3">>}),
    ?assertEqual(bitstring_to_base32(<<4>>), {ok, <<"4">>}),
    ?assertEqual(bitstring_to_base32(<<194>>), {ok, <<"62">>}),
    ?assertEqual(bitstring_to_base32(<<18446744073709551615:64/integer>>),
		 {ok, <<"FZZZZZZZZZZZZ">>}),
    ?assertEqual(bitstring_to_base32(<<42>>), {ok, <<"1A">>}).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
-spec bitstring_to_base32(iolist() | binary()) -> {ok, string()}.
bitstring_to_base32(List) 
  when is_list(List) ->
    bitstring_to_base32(list_to_binary(List));
bitstring_to_base32(<<0:3, A:5/integer>>) ->
    {ok, struct(A)};
bitstring_to_base32(Bitstring) 
  when is_bitstring(Bitstring)->
    Shift = bit_size(Bitstring) rem 5,
    bitstring_to_base32_shift(Shift, Bitstring, <<>>).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
% -spec bitstring_to_base32(_, _) -> ok.
bitstring_to_base32(<<>>, Buf) ->
    {ok, Buf};
bitstring_to_base32(<<Head:5/integer, Tail/bitstring>>, Buf) ->
    Base32 = struct(Head),
    Return = <<Buf/bitstring, Base32/bitstring>>,
    bitstring_to_base32(Tail, Return).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
% -spec bitstring_to_base32_shift(_,_,_) -> ok.
bitstring_to_base32_shift(0, Bitstring, Buf) ->
    bitstring_to_base32(Bitstring, Buf);
bitstring_to_base32_shift(Shift, Bitstring, Buf) ->
    <<R:Shift/integer, Tail/bitstring>> = Bitstring,
    Base32 = struct(R),
    Return = <<Buf/bitstring, Base32/bitstring>>,
    bitstring_to_base32(Tail, Return).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
% -spec decode(Data) -> ok.
decode(Data) ->
    base32_to_bitstring(Data).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
base32_to_bitstring_test() ->
    ?assertEqual(base32_to_bitstring(<<"1A">>), {ok, <<42>>}),
    ?assertEqual(base32_to_bitstring(<<"FZZZZZZZZZZZZ">>), 
		 {ok, <<18446744073709551615:64/integer>>}),
    ?assertEqual(base32_to_bitstring(<<"fZZZZZZZZZZZZ">>), 
		 {ok, <<18446744073709551615:64/integer>>}),
    ?assertEqual(base32_to_bitstring(<<"FzzZZZZZZZZZZ">>), 
		 {ok, <<18446744073709551615:64/integer>>}),
    ?assertEqual(base32_to_bitstring(<<"FZZZZZZZZZZzz">>), 
		 {ok, <<18446744073709551615:64/integer>>}).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
-spec base32_to_bitstring(string()) -> {ok, iolist() | binary()}.
base32_to_bitstring(List) when is_list(List) ->
    base32_to_bitstring(list_to_binary(List));
base32_to_bitstring(Bitstring) 
  when is_bitstring(Bitstring)->
    base32_to_bitstring(Bitstring, <<>>).

%%--------------------------------------------------------------------
%%
%%--------------------------------------------------------------------
% -spce base32_to_bitstring(_,_) -> ok.
base32_to_bitstring(<<>>, Buf) ->
    Shift = 8 - (bit_size(Buf) rem 8),
    base32_to_bitstring_shift(<<0:Shift, Buf/bitstring>>);
base32_to_bitstring(<<$-, Tail/bitstring>>, Buf) ->
    base32_to_bitstring(Tail, Buf);
base32_to_bitstring(<<$->>, _) ->
    {ok, <<>>};
base32_to_bitstring(<<Head/integer>>, <<>>) ->
    Symbol = struct(<<Head>>),
    {ok, <<0:3, Symbol:5/integer>>};
base32_to_bitstring(<<Head/integer, Tail/bitstring>>, Buf) ->
    Symbol = struct(<<Head>>),
    base32_to_bitstring(Tail, <<Buf/bitstring, Symbol:5/integer>>).
base32_to_bitstring_shift(<<_:8, Return/bitstring>>) ->
    {ok, Return}.
