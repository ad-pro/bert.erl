-include_lib("eunit/include/eunit.hrl").
 
%% encode
 
encode_list_nesting_test() ->
  Bert = term_to_binary([foo, {bert, true}]),
  Bert = encode([foo, true]).
 
encode_tuple_nesting_test() ->
  Bert = term_to_binary({foo, {bert, true}}),
  Bert = encode({foo, true}).
  
round_trip_dict_test() ->
  D = dict:store("my", balls, dict:store("number", 1234, dict:store("suckit", [], dict:new()))),
  Bin = encode(D),
  ?assertEqual(D, decode(Bin)).

=======
 
decode_list_nesting_test() ->
  Bert = term_to_binary([foo, {bert, true}]),
  Term = [foo, true],
  Term = decode(Bert).
 
decode_tuple_nesting_test() ->
  Bert = term_to_binary({foo, {bert, true}}),
  Term = {foo, true},
  Term = decode(Bert).