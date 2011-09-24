%%% See http://github.com/mojombo/bert.erl for documentation.
%%% MIT License - Copyright (c) 2009 Tom Preston-Werner <tom@mojombo.com>

-module(bert).
-version('1.1.0').
-author("Tom Preston-Werner").

-export([encode/1, decode/1]).
-export([encode64/1, decode64/1]).

%%---------------------------------------------------------------------------
%% Public API

-spec encode(term()) -> binary().
encode(Term) ->
    term_to_binary(encode_term(Term)).

-spec decode(binary()) -> term().
decode(Bin) ->
    decode_term(binary_to_term(Bin)).

-spec encode64(binary()) -> binary().
encode64(Term) ->
    base64:encode(encode(Term)).

-spec decode64(binary()) -> binary().
decode64(Term) ->
    decode(base64:decode(Term)).

%%---------------------------------------------------------------------------
%% Encode

-spec encode_term(term()) -> term().
encode_term(Term) ->
    case Term of
        [] -> {bert, nil};
        true -> {bert, true};
        false -> {bert, false};
        Dict when is_tuple(Term) andalso element(1, Term) =:= dict ->
            {bert, dict, [{encode_term(K), encode_term(V)}
                          || {K, V} <- dict:to_list(Dict)]};
        List when is_list(Term) ->
            [encode_term(V2) || V2 <- List];
        Tuple when is_tuple(Term) ->
            TList = tuple_to_list(Tuple),
            TList2 = [encode_term(V3) || V3 <- TList],
            list_to_tuple(TList2);
        _Else -> Term
    end.

%%---------------------------------------------------------------------------
%% Decode

-spec decode_term(term()) -> term().
decode_term(Term) ->
    case Term of
        {bert, nil} -> [];
        {bert, true} -> true;
        {bert, false} -> false;
        {bert, dict, Dict} ->
            L = [decode_term(V) || V <- Dict], dict:from_list(L);
        {bert, _Other} = Bert5 -> Bert5;
        List when is_list(Term) ->
            [decode_term(V1) || V1 <- List];
        Tuple when is_tuple(Term) ->
            TList = tuple_to_list(Tuple),
            TList2 = [decode_term(V2) || V2 <- TList],
            list_to_tuple(TList2);
        _Else -> Term
    end.
