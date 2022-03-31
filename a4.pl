% CISC 360 a4, Winter 2022
%
% See a4.pdf for instructions

/*
 * Q1: Student ID
 */
student_id( 20182972 ).
other_student_id( 20155672 ).
% if in a group, uncomment the above line and put the other student ID between the ( )

/*
 * Q2: evalF in Prolog
 *
 */
/*
  This question uses formulas similar to Haskell a3:

  top              truth (always true)
  bot              falsehood (contradiction)
  and( P1, P2)     conjunction of P1 and P2
  or( P1, P2)      disjunction of P1 and P2
  implies( P, Q)   implication (P -> Q)
  atom( a)         atomic proposition

For example, the a3 Haskell expression

   Implies (And vA vB) Top

where vA = Atom "A"
  and vB = Atom "B"

can be represented in Prolog as

   implies( and( atom(a), atom(b)), top)
*/

/*
  A valuation is a list of pairs of atom names and booleans.
  For example:

      [(a, false), (b, true)]

  is a valuation that says "a is false and b is true".
 
  evalF( Valu, Q, Result)
  
  Given a valuation Valu and a formula Q,
    Result = true   if  Q evaluates to true under Valu,
  and
    Result = false  if  Q evaluates to false under Valu.
*/
evalF( _, top, true).
evalF( _, bot, false).

% member: built-in predicate: member(Elem, List) is true iff
%  Elem is an element of List.
evalF( Valu, atom(V), Result) :- member((V, Result), Valu).

evalF( Valu, and(Q1, Q2), true)  :- evalF( Valu, Q1, true),
                                    evalF( Valu, Q2, true).
evalF( Valu, and(Q1, _),  false) :- evalF( Valu, Q1, false).
evalF( Valu, and(_,  Q2), false) :- evalF( Valu, Q2, false).
                                  
/* 
Q2:  Add clauses for:  or
                       implies
*/

evalF( Valu, or(Q1, _), true) :- evalF( Valu, Q1, true).
evalF( Valu, or( _, Q2), true) :- evalF( Valu, Q2, true).
evalF( Valu, or(Q1, Q2), false) :- evalF( Valu, Q1, false),
                                   evalF( Valu, Q2, false).

evalF( Valu, implies(Q1, _), true) :- evalF( Valu, Q1, false).
evalF( Valu, implies( _, Q2), true) :- evalF( Valu, Q2, true).
evalF( Valu, implies(Q1, Q2), false) :- evalF( Valu, Q1, true),
                                        evalF( Valu, Q2, false).

/*
 * Q3: Prime numbers
 */
 
/*
  findFactor(N, F): Given an integer N ≥ 2,
                     look for a factor F' of N, starting from F:
                     findFactor(N, F) true iff
                                           there exists F' in {F' | (F' >= F) and (F' * F') < N}
                                             such that (N mod F) = 0.
*/
findFactor(N, F) :- N mod F =:= 0.

findFactor(N, F) :- N mod F =\= 0,
                    F * F < N,
                    Fplus1 is F + 1,
                    findFactor(N, Fplus1).
/*
  isPrime(N, What)

  Given an integer N >= 2:
    What = prime           iff   N is prime
    What = composite       iff   N is composite
*/

isPrime(2, prime).
isPrime(N, composite) :- N > 2,    findFactor(N, 2).
isPrime(N, prime)     :- N > 2, \+ findFactor(N, 2).
%                               ^^
%                               "not"

/*
  findPrimes(Numbers, Primes)
    Primes = all prime numbers in Numbers
 
  Q3a. Replace the word "change_this" in the rules below.
       Hint:  Try to use  findPrimes(Xs, Ys).
*/
findPrimes([], []).

/*
  In this rule, we include X in the output: [X | Ys].
  So this rule should check that X is prime.
*/
findPrimes([X | Xs], [X | Ys]) :- isPrime(X,prime),
                                findPrimes(Xs, Ys).

/*
  In this rule, we do not include X in the output.
  So this rule should check that X is composite.
*/
findPrimes([X | Xs], Ys ) :-  \+isPrime(X,prime),
                                findPrimes(Xs, Ys).


/*
  upto(X, Y, Zs):
  Zs is every integer from X to Y

  Example:
     ?- upto(3, 7, Range)
     Range = [3, 4, 5, 6, 7]
*/
upto(X, X, [X]).
upto(X, Y, [X | Zs]) :-
    X < Y,
    Xplus1 is X + 1,
    upto(Xplus1, Y, Zs).

/*
  primes_range(M, N, Primes)
    Primes = all prime numbers between M and N
    Example:
      ?- primes_range(60, 80, Primes).
      Primes = [61, 67, 71, 73, 79] .

 Q3b. Replace the word "change_this" in the rule below.
      HINT: Use upto and findPrimes.
*/

primes_range(M, N, Primes) :- upto(M, N, Range), findPrimes(Range, Primes).
                              