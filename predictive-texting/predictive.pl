% This simulates predictive text entry from phones with numeric keyboards. The core logic to convert
% a sequence of numbers to possible words only takes three prolog rules. Tested and developed in SWI
% Prolog, can be used through external interface from other languages or in swi-pl shell.

% To add words on the fly in an interactive session:
% ?- assert(word([t,e,s,t])).
% true.


% Some nifty things to do here include non-specified-length queries like:
%% ?- convert_word([8 | X], Y).
%% X = [4, 4, 7],
%% Y = [t, h, i, s] ;
%% X = [3, 7, 8],
%% Y = [t, e, s, t] ;
%% X = [6, 3, 2, 9],
%% Y = [t, o, d, a, y] ;
%% false.

% For a true predictive text system with completion suggestions, word use frequencies would be
% recorded and referenced. That could be done pretty easily in a wrapper app that just called out to
% this in between number inputs (and that could also handle adding words to the dict, etc.

head( [H | _], H).

% Define the relationships between letters and phone keypad numbers.
letter_list([ a, b, c ], 2).
letter_list([ d, e, f ], 3).
letter_list([ g, h, i ], 4).
letter_list([ j, k, l ], 5).
letter_list([ m, n, o ], 6).
letter_list([ p, q, r, s ], 7).
letter_list([ t, u, v ], 8).
letter_list([ w, x, y, z ], 9).

% Define some initial words. Set the word predicate to be dynamic so it can be modified later.
:- dynamic(word/1).
word([t,h,i,s]).
word([i,s]).
word([a]).
word([t,e,s,t]).
word([t,o,d,a,y]).

% Convert sequences of digits to sequences of letter matches.
convert([ Digit ], [ Letter ]) :- letter_list(X, Digit), member(Letter, X).
convert([ NH | NT ], [ WH | WT ]) :- head(NT,_), convert([ NH ], [ WH ]), convert(NT, WT).
% Checking for a head of the tail avoids infinite looping or stack overflow without needing a not.
% So it still works to generate multi-element lists given convert(X, Y).

% Convert sequences of digits to sequences of letters that are also known to be words.
convert_word(Numbers, Letters) :- word(Letters), convert(Numbers, Letters).
% If we don't declare Letters to be a word first, this blows up quickly.
