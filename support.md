HOA Format Tool Support
=======================

The following tools implement support for the [HOA format](index.html), either as output or as input.


`jhoafparser` library
---------------------

This is a Java parser for the HOA format.  This parser includes an abstraction layer (`HOAConsumer`) allowing applications to react to the different parts of the format.

**LINK MISSING**

`jhoafparser` is distributed under the [GNU Lesser General Public License, version 2.1](https://www.gnu.org/licenses/lgpl-2.1.html)

`ltl2dstar`
-----------

[`ltl2dstar`](http://ltl2dstar.de/) can convert LTL formulas into the following three kinds of automata:

- deterministic Rabin automata,
- deterministic Street automata,
- non-deterministic Büchi automata (after conversion from DRA or DSA).

Those automata can be output in the HOA format since version 0.5.2.

`ltl2dstar`'s source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`ltl3ba`
--------

Since version 1.1.0, [`ltl3ba`](http://sourceforge.net/projects/ltl3ba/) can translate LTL formulas into three kinds of automata that can be output in HOA:

- Büchi automata,
- transition-based generalized Büchi automata,
- (very weak) co-Büchi alternating automata.

`ltl3ba`'s source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`ltl3dra`
---------

Since version 0.2 [`ltl3dra`](http://sourceforge.net/projects/ltl3dra/) can translate LTL formulas into two kinds of automata that can be output in HOA:

- deterministic Rabin automata,
- deterministic transition-based generalized Rabin automata.

`ltl3dra`'s source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`Prism`
-------

A development version of Prism (**LINK MISSING**) supports the acceptance conditions defined by HOA in its generality, and will use `jhoafparser` to input HOA.

Prism's source code is distributed under the [GNU General Public License, version 2](http://www.gnu.org/licenses/gpl-2.0.html).

`Rabinizer`
-----------

[Rabinizer 3](https://www7.in.tum.de/~kretinsk/rabinizer3.html) can translate can translate LTL formulas into four kinds of automata that can be output in HOA:

- deterministic Rabin automata,
- deterministic transition-based Rabin automata,
- deterministic generalized Rabin automata,
- deterministic transition-based generalized Rabin automata.

*The web page and source code of Rabinizer does not state any license.*

`Spot`
------

[Spot 1.2.6](http://spot.lip6.fr/wiki/GetSpot) contains `ltl2tgba`, a tool that translates LTL or PSL formulas, and `dstar2tgba` a tool that convert `ltl2dstar`'s Rabin or Streett output (expressed in the original DSTAR format, not yet in HOA).  Both tools can output the following types of automata in the HOA format:

- transition-based generalized Büchi automata,
- Büchi automata,
- monitors.

The development version of what will become Spot 2.0 now has several tools that can output or input these automata.  In addition to `ltl2tgba` and `dstar2tgba`, there are the following tools:
- `randaut`: generates random generalized Büchi automata
- `autfilt`: reads automata (in HOA, LBT's format or never claims), transform them, filter them, and output them (in HOA, LBT's format, never claims, or dot output for graphical display)
- `ltlcross`: compares and checks LTL/PSL translators (can read HOA, LBT, never claims, or ltl2dstar's output)
- `ltldo`: Wrap existing LTL to Büchi translator tools, providing them all the range of input and output Spot supports.  For instance running `ltldo spin -f GFa -H` will use [spin](http://spinroot.com/) to translate `[]<>a` and convert the result in the HOA format.

In these tools HOA support is currently limited to non-alternating automata with a generalized Büchi acceptance condition (this includes Büchi and the trivial "all accepting" condition).  The implemented C++ parser support streaming of automata, where the input can mix the HOA format, LBT format and never claims.

Until a release is done, a fully functionnal development version can be downloaded [here](https://www.lrde.epita.fr/~adl/dl/spot-1.99a.tar.gz), and the documentation of the tools offered can be read [there](https://www.lrde.epita.fr/~adl/dl/spot-1.99-userdoc/tools.html).

Spot's source code is distributed under the [GNU General Public License, version 3](http://www.gnu.org/licenses/gpl-3.0.html).
