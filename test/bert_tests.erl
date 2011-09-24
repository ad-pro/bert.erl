-module(bert_tests).
-include_lib("eunit/include/eunit.hrl").
-import(bert, [encode/1, decode/1]).

%% encode

encode_list_nesting_test() ->
  Bert = term_to_binary([foo, {bert, true}]),
  Bert = encode([foo, true]).

encode_tuple_nesting_test() ->
  Bert = term_to_binary({foo, {bert, true}}),
  Bert = encode({foo, true}).

encode_dict_test() ->
  Bert = term_to_binary({ bert, dict,
                          dict:to_list(dict:store(foo, true, dict:new())) }),
  Bert = encode(dict:store(foo, true, dict:new())).

%% decode

decode_list_nesting_test() ->
  Bert = term_to_binary([foo, {bert, true}]),
  Term = [foo, true],
  Term = decode(Bert).

decode_tuple_nesting_test() ->
  Bert = term_to_binary({foo, {bert, true}}),
  Term = {foo, true},
  Term = decode(Bert).

decode_dict_test() ->
  Bert = term_to_binary({ bert, dict,
                          dict:to_list(dict:store(foo, true, dict:new())) }),
  Term = dict:store(foo, true, dict:new()),
  Term = decode(Bert).

decode_dict_nesting_test() ->
  Bert = term_to_binary({ bert, dict,
                          dict:to_list(dict:store(a,
                                                  { bert, dict,
                                                    dict:to_list(dict:store(b, "b", dict:new()))
                                                  },
                                                  dict:new())) }),
  Term = dict:store(a, dict:store(b, "b", dict:new()), dict:new()),
  Term = decode(Bert).

%% both

round_trip_dict_test() ->
  D = dict:store("my", balls, dict:store("number", 1234, dict:store("suckit", [], dict:new()))),
  Bin = encode(D),
  ?assertEqual(D, decode(Bin)).
