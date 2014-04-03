Hanoi Omega Automata Format
===========================

This working document describes the Hanoi Omega-Automata (HOA) format.  The name is a reference to the ATVA'13 conference, which was organized in Hanoi, and where the foundation of this format was laid out.

Goals
-----

Design a format, inspired from [`ltl2dstar`'s format](http://www.ltl2dstar.de/docs/ltl2dstar.html#output-format), but which:

- is more compact when a lot of atomic propositions are used, or when the automaton is not complete.
- supports non-deterministic omega-automata.
- supports states-labeled omega-automata. 
- supports different types of acceptance conditions, preferably in a way that is easy to extend.
- consider new lines as any other white-space characters, i.e., as token separators.  All the examples below should work even after newlines have been removed or moved around (this typically happens if you copy/paste an automaton into a mailer that reformats paragraphs).  A use case for not using any newline is when compiling results from experiments into a file, with one automaton per line (maybe with other measurments if that is a CSV file), for easier filtering with line-oriented tools such as grep/cut/sed.


Supported Types of Omega-Automata
---------------------------------

The HOA format supports many types of finite automata over infinite words: automata with labels on transitions or labels on states, and with wide range of acceptance conditions based on states or transitions appearing (in)finitely often in an automaton run.  Instead of providing semantics for each supported type of omega-automata, we provide only semantics for automata with labels on transitions and transition-based accepting conditions. Labels on states and state-based acceptance are formaly seen as syntactic sugar (their semantics fully corresponding to the expected one).  Automata in HOA format can have more initial states. 


Preliminary Notes
-----------------

Input alphabets of all considered automata types consist of letters that are subsets of atomic propositions (AP).  To make the automata description more concise, we label states or transitions of automata with Boolean formulas over AP representing choices between multiple letters.  A Boolean formula represents the set of letters satisfying the formula: a letter satisfies a formula if the valuation assigning True to all atomic proporistions in the letter and False to all other atomic propositions is a model of the formula.  We use B(AP) do denote the set of Boolean formulas over AP.

The format considers acceptance conditions built on a finite set {S₀,S₁,…,Sₖ} of acceptance sets.  Each acceptance set Sᵢ is a subset of automata states and transitions.  Loosely speaking, an acceptance condition says which acceptance sets should be visited infinitely often and which only finitely often by a run to be accepting.  More precisely, an acceptance condition is a Boolean formula over atoms of the form F(Sᵢ), F(¬Sᵢ), I(Sᵢ), or I(¬Sᵢ).  The atom F(Sᵢ) indicates that all states and transitions in Sᵢ should occur finitely often in the run, while I(Sᵢ) denotes that some state or transition of Sᵢ should be visited infinitely often.  A state in an acceptance set is formally seen as an abbreviation for inclusion of all transitions leaving the state.  The negation symbol ¬ represents the complement of the set with respect all transitions.  Many examples of classical acceptance conditions (Büchi, Rabin, Streett, Parity) will be given later.
  
The format has a common approach to atomic propositions, states, and acceptance sets: the number of propositions/states/sets, say n, is first declared and all propositions/states/sets are then referenced as 0,1,…,n-1. 


Common Tokens
-------------

- `STRING`: a C-like double-quoted string `"(\\.|[^\\"])*"`

- `INT`: `0|[1-9][0-9]*`
  A non-negative integer less than 2^31 written in base 10 (with no useless `0` at the beginning).

- comments: `/* … */`
  Comments may be introduced between any token by enclosing them with `/*` and `*/` (with proper nesting, i.e.  `/*a/*b*/c*/`  is one comment).  C++-style comments are not considered because they require newlines.  Tools can use comments to output additional information (e.g. debugging data) that should be discarded upon reading.

- whitespace: `[ \t\n\r]`
  Except in double-quoted strings and comments, whitespace is used only for tokenization and can be discarded afterwards.

- `IDENTIFIER`: `[a-zA-Z_][0-9a-zA-Z_]*`
  A C-like identifier.

- `HEADERNAME`: `[a-zA-Z_-][0-9a-zA-Z_-]*:`
  Header names are likes identifiers, except that they may use dashes, and are immediately (i.e. not comment or space allowed) followed by a double colon.  If an `IDENTIFIER` is immediately followed by a double colon, it should be considered as a `HEADERNAME`.

General Layout
--------------

An automaton is output in two parts: a header, that supplies meta-data about the automaton (such as number of states and acceptance condition), and a body, encoding the automaton as a labeled graph.
The two parts are separated by a triple dash.

    automaton ::= header "---" body

Header
------

    header ::= formatversion headeritems*
    formatversion ::= "HOA:" IDENTIFIER
    headeritem ::= "States:" INT
                 | "Start:" INT*
                 | "AP:" INT STRING*
                 | "Acceptance:" INT acceptancecond
                 | "tool:" STRING STRING?
                 | "name:" STRING
                 | "properties:" IDENTIFIER*
                 | HEADERNAME (INT|STRING|IDENTIFIER)*

The header is a list of `headeritem`s (a `HEADERNAME` followed by some data).  Except for the "HOA:" item, which should always come first, the items may occur in any order.  Some `HEADERNAME`s have predefined semantics (and might be mandatory) as specified below.   This format also makes provision of additional (unspecified) header names to be used.

Any given `HEADERNAME` should occur at most once.  The case of the `HEADERNAME`'s initial is used to specify whether tool may safely ignore a header item they do not support: header items whose name start with an upper-case letter are expected to influence the semantic of the automaton: tools should at least warn about any such `HEADERNAME` they do not understand.  A `HEADERNAME` whose initial is lowercase may be safely ignored without affecting the semantics.

### `HOA:`

`HOA:` should always be the first token of the file.  It is followed by an identifier that represents the version of the format.  This document specifies the first version of this format so this header should appear as

    HOA: v1

### `States:`

This mandatory header item specifies the number of states in the automaton.  The states are assumed to be numbered consecutively from 0.   For instance:

    States: 10

specifies an automaton with 10 states numbered from 0 to 9.

An empty automaton, with no states, can be specified with `States: 0`.

### `Start:`

This optional header item lists the initial states (given by their number).  The list may be empty, which is the same as omitting this header item.

### `AP:`

`AP:` gives the number of atomic propositions, followed by the name of each of these atomic propositions (using double-quoted C-strings).  Atomic propositions are implicitely numbered from left to right, starting at 0.

For instance

    AP: 3 "a" "proc@state" "a[x] >= 2"

specifies three atomic propositions:

- atomic proposition 0 is `"a"`
- atomic proposition 1 is `"proc@state"`
- atomic proposition 2 is `"a[x] >= 2"`

The number of double-quoted strings must match exactly the number given.  This number may be 0, in which case it is not followed by any string, and this is equivalent to not using `AP:`.

### `Acceptance:`

    headeritem ::= … | "Acceptance:" INT acceptancecond

    acceptancecond ::= "I" "!"? INT
                     | "F" "!"? INT
                     | (acceptancecond)
                     | acceptancecond & acceptancecond
                     | acceptancecond | acceptancecond

is used to specify the number of acceptance sets used by the automaton (if m sets are declared, these sets are numbered from 0 to m-1), and how these acceptance sets are used to build the acceptance condition.
The acceptance condition is specified as a positive Boolean combination of atoms of the form `Fx`, `F!x`, `Ix`, `I!x`  where:

- `x` is a integer in [0,m) representing an accepting set,
- `!x` represent the complement of that set,
- `F` and `I` specify whether that set should be visited finitely or infinitely often.

The `&` operator has priority over `|`, and parentheses may be used for grouping.

As explained previously, our semantics for acceptance are transition-based, so if an automaton uses both accepting states and accepting transitions, the acceptance of the states should be transfered to their outgoing transitions so that complementation of acceptance sets can be performed with respect to all transitions.

For instance

    Acceptance: 2 (F!0 & I1)

declares two acceptance sets.  A run of the automaton is accepting if it visits the complement of the first set finitely often, and if it visits the second set infinitely often.  More examples will be given in the next section.

### `tool:` and `name:`

    headeritem ::= …
                 | "tool:" STRING STRING?
                 | "name:" STRING

These optional header items can be used to record information about the tool used to produce the automaton, or to give a name to this automaton.  The two arguments of `tool:` corresponds respectively to the tool's name and its (optional) version number.

For instance:

    tool: "ltl-translate" "1.2-alpha"
    name: "BA for GFa & GFb"


### `properties:`

    headeritem ::= … | "properties:" IDENTIFIER*

The optional `properties:` header name can be followed by a list of identifiers that gives additional information about the automaton.  These information should be redundant in the sense that ignoring them should not impact the behavior of the automaton.  For instance stating that an automaton is deterministic with

    properties: deterministic

may enable tools that read the automaton to choose a better data structure to store this automaton, but ignoring this header item will not suddenly make the automaton non-deterministic.

The following properties have specified meanings, but additional may be added, and tools may simply ignore those they do not know:

- `deterministic` hints that the automaton is deterministic, i.e., it has at most one initial state, and the outgoing transitions of each state have disjoint labels.
- `complete` hints that the automaton is complete, i.e., it has at least one state, and the transition function is total.
- `unambiguous` hints that the automaton is unambiguous, i.e., for each word there is at most one accepting run of the automaton.

Example of Acceptance Specifications
------------------------------------

### Büchi

Simply:

    Acceptance: 1 I0

### Generalized Büchi or co-Büchi

A generalized automaton with three acceptance sets can be defined with:

    Acceptance: 3 I0&I1&I2

A deterministic automaton with such acceptance conditions could be complemented without changing its transition structure by simply complementing the acceptance, giving a generalized co-Büchi automaton:

    Acceptance: 3 F0|F1|F2

A promise automaton generated by the tableau construction of `ltl2tgba` could be output with

    Acceptance: 3 I!0 & I!1 & I!2

(Spot actually makes an extra pass at the end of the translation to complement the acceptance sets in order to obtain the more usual `I0&I1&I2` acceptance).

### Streett acceptance

Pairs of acceptance sets {(L₁,U₁),…,(Lₖ,Uₖ)}.  A run is accepting iff for each pair (Lᵢ,Uᵢ) if it visits Lᵢ infinitely often, then it also visits Uᵢ infinitely often.  Assuming k=3 and numbering these 6 sets from left (L₁) to right (U₃), this corresponds to:

    Acceptance: 6 (F0|I1)&(F2|I3)&(F4|I5)

Note that an acceptance set may be used more than once.  For instance when translating `(GF(a) -> GF(b)) & (GF(b) -> GF(c))` into a Streett automaton, it would make sense to use:

    Acceptance: 3 (F0|I1)&(F1|I2)

### Rabin acceptance

There are several equivalent presentations of Rabin acceptance, and working with tools that use different definitions is often a source of confusion.  Our notations of the acceptance condition accomodate all styles, while giving a clear and unambiguous semantics.

J. Klein, in [`ltl2dstar`](http://www.ltl2dstar.de/docs/ltl2dstar.html#dra_dsa), uses pairs {(L₁,U₁),…,(Lₖ,Uₖ)} where there should be some pair (Lᵢ,Uᵢ) such that states in Lᵢ are visited infinitely often, but states in Uᵢ are visited finitely often.   This is the complement of the Streett acceptance above:

    Acceptance: 6 (I0&F1)|(I2&F3)|(I4&F5)

K. Löding, in [his diploma thesis](http://automata.rwth-aachen.de/~loeding/diploma_loeding.pdf), uses pairs {(E₁,F₁),…,(Eₖ,Fₖ)} where Eᵢ should be visited finitely often, and Fᵢ should be visited infinitely often.  This is just a reordering of the previous pairs:

    Acceptance: 6 (F0&I1)|(F2&I3)|(F4&I5)

S. Krishnan, in [his ISAAC'94 paper](http://dx.doi.org/10.1007/3-540-58325-4_202), uses pairs {(L₁,U₁),…,(Lₖ,Uₖ)} such that the set of recurring states of a an accepting run should intersect Lᵢ and be included in Uᵢ, for some pair (Lᵢ,Uᵢ).  A similar definition is used by Manna and Pnueli in their "Hierarchy of Temporal Properties" paper.  This corresponds to:

    Acceptance: 6 (I0&F!1)|(I2&F!3)|(I4&F!5)


### Generalized Rabin acceptance

Rabin acceptance has been generalized in works by [Křetínský & Esparza](http://arxiv.org/abs/1204.5057) or [Babiak et al.](http://dx.doi.org/10.1007/978-3-319-02444-8_4).  They both translate LTL formulas into generalized Rabin automata in which the acceptance condition may look like {({L₁₁,L₁₂,L₁₃}, U₁), ({L₂₁,L₂₂}, U₂)}, and where a run is accepting if there exist some i such that the run visits infinitely often all the sets Lᵢⱼ and finitely often the set Uᵢ.  Such an acceptance condition can be specified with:

    Acceptance: 7 (I0&I1&I2&F3)|(I4&I5&F6)

### Parity automata

If we want the smallest number of acceptance set that is visited infinitely often to be even, we can write:

    Acceptance 5 I0 | (F0&F1&I2) | (F0&F1&F2&F3&I4)

or

    Acceptance 5 I0 | F0&F1&(I2 | F2&F3&I4)


Body of the Automaton
---------------------

The header is separated from the rest of the structure with `---`.

States should be numbered from 0 to n-1 and specified with the following grammar

    body             ::= (state-name edges)*
    // the optional dstring can be used to name the state for
    // cosmetic or debugging purposes, as in ltl2dstar's format
    state-name       ::= "State:" label? INT STRING? acc-sig?
    acc-sig          ::= "{" INT* "}"
    edges            ::= edge*
    edge             ::= label? INT acc-sig?
    label            ::= "[" label-expr "]"
    label-expr       ::= "t" | "f" | INT | "!" label-expr
                       | "(" label-expr ")"
                       | label-expr "&" label-expr
                       | label-expr "|" label-expr

The `INT` occurring in the `state-name` rule is the number of this state.  States should be numbered from 0 to n-1, may be listed in any order, but should all be listed (i.e., if the header has `States: 10` then the body should have ten `State: INT` statements, with all numbers from 0 to 9).   In addition to a number, a state may optionally be given a name (the `STRING` token) for cosmetic or practical purposes.

The `INT` occurring in the `edge` rule represent the destination state.

The `INT*` used in `acc-sig` represent the acceptance sets the state or edge belongs to.  Since we use transition-based acceptance, when `acc-sig` is used on a state to declare membership to some acceptance sets, it is syntactic sugar for the membership of all the outgoing transitions to this set.  For instance `State: 0 {1 3}` would states that all transitions leaving state 0 are in acceptance sets 1 and 3.

Finally, each `INT` used in `label-expr` denotes an atomic proposition. Recall that propositions are numbered in the order listed on the `AP:` line.

If a state has a `label`, no outgoing edge of this state should have a `label`: this should be used to represent state-labeled automata.  In our semantics, we have to view this as syntactic sugar for all outgoing transitions being labeled by this very same `label`.

If an edge has a `label`, all edges of this state should have a `label`.

If one state has no `label`, and no labeled edges, then there should be exactly 2^*a* edges listed, where *a* is the number of atomic propositions.  In this case, each edge corresponds to a transition, with the same order as in `ltl2dstar`. If a transition *t* is the *i*-th transition of a state (starting with 0), then the label of *t* can be deduced by interpreting *i* as a bitset. The label is a set of atomic propositions such that the atomic proposition *j* is in the set if the *j*-th least significant bit of *i* is set to 1.


Examples
--------

### Transition-based Rabin acceptance and explicit labels

    HOA: v1
    States: 2
    Start: 0
    Acceptance: 2 (F0 & I1)
    AP: 2 "a" "b"
    ---
    State: 0 "a U b"   /* An example of named state */
      [0 & !1] 0 {0}
      [1] 1 {0}
    State: 1
      [t] 1 {1}

### State-based Rabin acceptance and implicit labels

Because of implicit labels, the automaton necessarily has to be deterministic and complete.

    HOA: v1
    States: 3
    Start: 0
    Acceptance: 2 (F0 & I1)
    AP: 2 "a" "b"
    ---
    State: 0 "a U b" { 0 }
      2  /* !a  & !b */
      0  /*  a  & !b */
      1  /* !a  &  b */
      1  /*  a  &  b */
    State: 1 { 1 }
      1 1 1 1       /* four transitions on one line */
    State: 2 "sink state" { 0 }
      2 2 2 2

### TGBA with implicit labels

    HOA: v1
    name: "GFa & GFb"
    States: 1
    Start: 0
    Acceptance: 2 (I0 & I1)
    AP: 2 "a" "b"
    ---
    State: 0
      0       /* !a  & !b */
      0 {0}   /*  a  & !b */
      0 {1}   /* !a  &  b */
      0 {0 1} /*  a  &  b */

### TGBA with explicit labels

    HOA: v1
    name: "GFa & GFb"
    States: 1
    Start: 0
    Acceptance: 2 (I0 & I1)
    AP: 2 "a" "b"
    ---
    State: 0
    [!0 & !1] 0
    [0 & !1]  0 {0}
    [!0 & 1]  0 {1}
    [0 & 1]   0 {0 1}

### Non-deterministic State-based Büchi automaton (à la Wring)

Encoding `GFa` using state labels requires multiple initial states.

    HOA: v1
    name: "GFa"
    States: 2
    Start: 0 1
    Acceptance: 1 I0
    AP: 1 "a"
    ---
    State: [0] 0 {0}
      0 1
    State: [!0] 1
      0 1


Note that even if a tool has no support for state labels or multiple initial states, the above automaton could easily be transformed into a transition-based one upon reading.  It suffices to add a new initial state connected to all the original initial states, and then to move all labels onto incoming transitions.  Acceptance sets can be moved to incoming or (more naturally) to outgoing transitions.  For instance the following transition-based Büchi automaton is equivalent to the previous example:

    HOA: v1
    States: 3
    Start: 0
    Acceptance: 1 I0
    AP: 1 "a"
    ---
    State: 0
     [0] 1
     [!0]  2
    State: 1  /* former state 0 */
     [0] 1 {0}
     [!0] 2 {0}
    State: 2  /* former state 1 */
     [0] 1
     [!0] 2

### Mixing state-based and transition-based acceptance

Here is a Büchi automaton for `GFa | G(b <-> Xa)`.

    HOA: v1
    name: "GFa | G(b <-> Xa)"
    States: 1
    Start: 0
    Acceptance: 1 I0
    AP: 2 "a" "b"
    ---
    State: 0
     [t] 1
     [1] 2
     [!1] 3
    State: 1 "GFa"
     [0] 1 {0}
     [!0] 1
    State: 2 "a & G(b <-> Xa)" {0}
     [0&1] 2
     [0&!1] 3
    State: 3 "!a & G(b <-> Xa)" {0}
     [!0&1] 2
     [!0&!1] 3

In this automaton, marking states 2 and 3 as belonging to set 0
is equivalent to marking all their outgoing transitions as such:

    HOA: v1
    name: "GFa | G(b <-> Xa)"
    States: 1
    Start: 0
    Acceptance: 1 I0
    AP: 2 "a" "b"
    ---
    State: 0
     [t] 1
     [1] 2
     [!1] 3
    State: 1 "GFa"
     [0] 1 {0}
     [!0] 1
    State: 2 "a & G(b <-> Xa)"
     [0&1] 2 {0}
     [0&!1] 3 {0}
    State: 3 "!a & G(b <-> Xa)"
     [!0&1] 2 {0}
     [!0&!1] 3 {0}


Mixing state-based and transition-based acceptance can also be done in the same state.  For instance a state like:

    State: 1 {1}
     [0] 2
     [!0] 3 {0}

is equivalent to

    State: 1
     [0] 2 {1}
     [!0] 3 {0 1}


Formal Semantics of Omega-Automata
----------------------------------

Each omega-automaton described in this format can be seen as an automaton (AP,Q,R,I,F,Acc) with labels on transitions and transition-based acceptance, where:

- AP is a finite set of atomic propositions. We use B(AP) do denote the set of Boolean formulas over AP.
- Q is a finite set of states.
- R⊆Q⨯B(AP)⨯Q is a transition relation.  A triplet (s,ℓ,d)∈R represents a transition from s to d labeled by ℓ, where the label ℓ is a Boolean formula over AP.
- I⊆Q is a set of initial states.
- F={S₀,S₁,…,Sₖ} is a finite set of acceptance sets.  Each acceptance set **Sᵢ⊆R** is a subset of **transitions**.
- Acc is an Boolean formula over {F(S),F(¬S),I(S),I(¬S)|S∈F}. 

The automaton is interpreted over infinite words, where letters are subsets of AP. A run over a word w=a₀a₁… is an infinite sequence (s₀,ℓ₀,s₁)(s₁,ℓ₁,s₂)… of transitions such that s₀∈I and each ℓᵢ is True in valuation assigning True to atomic propositions in aᵢ and False to all other atomic propositions. A run is accepting if it satisfies the acceptance condition Acc, where the run satisfies
- F(S) if all transitions in S appear only finitely often in the run. 
- F(¬S) if all transitions outside S appear only finitely often in the run.
- I(S) if some transition in S appears infinitely often in the run.
- I(¬S) if some transition outside S appears infinitely often in the run.
The automaton recognizes the language of all words for which there exists an accepting run of the automaton. 

As mentioned above, the format also supports labels on states. This is formally seen as an abbreviation for the situation where all transitions leaving the state have this label. The format even admits automata combining states with labels, unlabeled states with labels on all outgoing transitions, and unlabeled states with implicitely labeled transitions. 

The format supports both state-based and transition-based acceptance sets.  In our transition-based semantics, as illustrated by our previous examples, marking a state as belonging to some acceptance set with (for instance) `State: 0 {1 3}` is syntactic sugar for marking all the outgoing transitions of state 0 as belonging to acceptance sets 1 and 3.  This is especially important if one combines states and transitions in an acceptance set and use negation of this acceptance sets in the acceptance condition.


Semantics for Pure State-Based Acceptance
-----------------------------------------

In tools that manipulate only state-based acceptance, acceptance will only be used for states, and therefore the transition-based semantics are unconvenient.   For these tools, one can consider the following semantics.

The omega-automata are represented by a tuple (AP,Q,R,I,F,Acc), where:

- AP is a finite set of atomic propositions.
- Q is a finite set of states.
- R⊆Q⨯B(AP)⨯Q is a transition relation,
- I⊆Q is a set of initial states,
- F={S₀,S₁,…,Sₖ} is a finite set of acceptance sets.  Each acceptance set **Sᵢ⊆Q** is a subset of **states**.
- Acc is an acceptance condition.

The only difference with the transition-based definition is that Sᵢ⊆Q instead of Sᵢ⊆R.  The acceptance condition is still a formula defined over F(Sᵢ), F(¬Sᵢ), I(Sᵢ), or I(¬Sᵢ), but this time each Sᵢ is a sets of **states** that must occur infinitely or finitely often in accepting runs, and  the complement operation ¬ should be done with respect to Q instead of R.

An automaton with state-based acceptance can be trivially converted to transition-based acceptance by shifting the acceptence set membership from each state to its outgoing transitions, and the two semantics are compatible in the sense that the two automata would recognize the same language.  If the automaton has no dead states (i.e., states without successor), the result of such transformation can easily be reversed.

The two semantics disagree slightly on the handling of dead states. The state-based semantics allow dead states to appear in acceptance sets, while there is no way to do that with transition-based acceptance.  This difference is inconsequential: a dead state is never going to contribute anything useful the recognized language.
