HOA Format Tool Support
=======================

The following tools implement support for the [HOA format](index.html), either as output or as input.


`jhoafparser` library
---------------------

[`jhoafparser`](http://www.ltl2dstar.de/jhoafparser/) is a Java-based parser for the HOA format. The parser includes an abstraction layer (`HOAConsumer`) allowing applications to react to the different parts of the format, as well as a command-line tool that can be used for validation of HOA automata.

`jhoafparser` is distributed under the [GNU Lesser General Public License, version 2.1](https://www.gnu.org/licenses/lgpl-2.1.html)

`ltl2dstar`
-----------

Since version 0.5.2, [`ltl2dstar`](http://ltl2dstar.de/) can convert LTL formulas into three kinds of automata that can be output in the HOA format:

- deterministic Rabin automata,
- deterministic Street automata,
- non-deterministic Büchi automata (after conversion from DRA or DSA).

`ltl2dstar`'s source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`ltl3ba`
--------

Since version 1.1.0, [`ltl3ba`](http://sourceforge.net/projects/ltl3ba/) can translate LTL formulas into three kinds of automata that can be output in the HOA format:

- Büchi automata,
- transition-based generalized Büchi automata,
- very weak co-Büchi alternating automata.

`ltl3ba`'s source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`ltl3dra`
---------

Since version 0.2, [`ltl3dra`](http://sourceforge.net/projects/ltl3dra/) can translate LTL formulas into three kinds of automata that can be output in the HOA format:

- deterministic Rabin automata,
- deterministic transition-based generalized Rabin automata,
- very weak co-Büchi alternating automata.

`ltl3dra`'s source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`PRISM`
-------

[PRISM](http://www.prismmodelchecker.org/) uses omega automata for probabilistic verification of LTL (and similar logics) against probabilistic models such as Markov chains and Markov decisions processes.

The current development version of PRISM (**LINK MISSING**), which will form the next public release, includes support for plugging in external LTL-to-automaton generation tools using the HOA format. PRISM incorporates `jhoafparser` for the purposes of importing the generated automata and now supports verification of a variety of acceptance conditions: arbitrary generic acceptance conditions for Markov chains and Rabin or generalized Rabin conditions for Markov decision processes.

PRISM's source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`Rabinizer`
-----------

[Rabinizer 3](https://www7.in.tum.de/~kretinsk/rabinizer3.html) can translate can translate LTL formulas into four kinds of automata that can be output in the HOA format:

- deterministic Rabin automata,
- deterministic transition-based Rabin automata,
- deterministic generalized Rabin automata,
- deterministic transition-based generalized Rabin automata.

*The web page and source code of Rabinizer does not state any license.*

`Spot`
------

[Spot 1.2.6](http://spot.lip6.fr/wiki/GetSpot) contains `ltl2tgba`, a tool that translates LTL or PSL formulas, and `dstar2tgba` a tool that convert `ltl2dstar`'s Rabin or Streett output (expressed in the original DSTAR format, not yet in the HOA format).  Both tools can output the following types of automata in the HOA format:

- transition-based generalized Büchi automata,
- Büchi automata,
- monitors.

The development version of what will become Spot 2.0 has several tools that can output or input these automata.  In addition to `ltl2tgba` and `dstar2tgba`, there are the following tools:
- `randaut`: generates random generalized Büchi automata
- `autfilt`: reads automata (in the HOA format, the LBT's format or never claims), transform them, filter them, and output them (in the HOA format, the LBT's format, as never claims, or dot output for graphical display)
- `ltlcross`: compares and checks LTL/PSL translators (can read HOA, LBT, never claims, or ltl2dstar's output)
- `ltldo`: Wrap existing LTL to Büchi translator tools, providing them all the range of input and output Spot supports.  For instance running `ltldo spin -f GFa -H` will use [spin](http://spinroot.com/) to translate `[]<>a` and convert the result to the HOA format.

In these tools HOA support is currently limited to non-alternating automata with a generalized Büchi acceptance condition (this includes Büchi and the trivial "all accepting" condition).  The implemented C++ parser supports streaming of automata, where the input can mix the HOA format, the LBT format and never claims.

Until a release is done, a fully functionnal development version can be downloaded [here](https://www.lrde.epita.fr/~adl/dl/spot-1.99a.tar.gz), and the documentation of the tools offered can be read [there](https://www.lrde.epita.fr/~adl/dl/spot-1.99-userdoc/tools.html).

Spot's source code is distributed under the [GNU General Public License, version 3](http://www.gnu.org/licenses/gpl-3.0.html).
