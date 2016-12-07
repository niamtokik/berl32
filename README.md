# berl32

Quick and Dirty Crockford Base32 Erlang Implementation

## Build

	$ rebar3 compile
	
## Encoding

	> berl32:encode("*").
	{ok,<<"1A">>}
	
	> berl32:encode(<<"*">>).
	{ok,<<"1A">>}

	> berl32:encode("test").
	{ok,<<"1T6AWVM">>}
	
	> berl32:encode(<<"test">>).
	{ok,<<"1T6AWVM">>}
	
	> berl32:encode(<<18446744073709551615:64/integer>>).
	{ok, <<"FZZZZZZZZZZZZ">>}
	
## Decoding

	> berl32:decode(<<"1A">>).
	{ok,<<"*">>}
	
	> berl32:decode("1A").
	{ok, <<"*">>}
	
	> berl32:decode(<<"FZZZZZZZZZZZZZZ">>).
	{ok,<<"ÿÿÿÿÿÿÿÿÿ">>}

## Todo

 * add checksum/control character support
 * add more unit test
 * add more documentation
 * add profiling and benchmarking
