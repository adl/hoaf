HOA Format Tool Support
=======================

The following tools implement support for the [HOA format](index.html), either as output or as input.

For your convenience, we provide a [live CD](#live-cd) to play around with the tools.

`jhoafparser` and `cpphoafparser` library
-----------------------------------------

[`jhoafparser`](http://automata.tools/hoa/jhoafparser/) 
and
[`cpphoafparser`](http://automata.tools/hoa/cpphoafparser/)
are Java/C++-based parser libraries for the HOA format.
The parser includes an abstraction layer (`HOAConsumer`) allowing applications to react to the different parts of the format, as well as a command-line tool that can be used for validation of HOA automata.

`jhoafparser` and `cpphoafparser` is distributed under the [GNU Lesser General Public License, version 2.1](https://www.gnu.org/licenses/lgpl-2.1.html)

`ltl2dstar`
-----------

Since version 0.5.2, [`ltl2dstar`](http://ltl2dstar.de/) can convert LTL formulas into three kinds of automata that can be output in the HOA format:

- deterministic Rabin automata,
- deterministic Street automata,
- non-deterministic Büchi automata (after conversion from DRA or DSA).

Since version 0.5.3, [`ltl2dstar`](http://ltl2dstar.de/) can also read non-deterministic Büchi
automata in HOA format, either from external LTL-to-Büchi translators or as the input automaton
for determinization.

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

The [current beta version of PRISM](http://www.prismmodelchecker.org/download.php), which will form the next public release, includes support for plugging in external LTL-to-automaton generation tools using the HOA format. PRISM incorporates `jhoafparser` for the purposes of importing the generated automata and now supports verification of a variety of acceptance conditions: arbitrary generic acceptance conditions for Markov chains and Rabin or generalized Rabin conditions for Markov decision processes.

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

[Spot 1.99.1](https://spot.lrde.epita.fr) has several tools that can output or input these automata, and that support the generic acceptance condition.  In addition to `ltl2tgba` and `dstar2tgba` (that can output generalized Büchi automata in HOA), there are the following tools:
- `randaut`: generates random automata with any acceptance condition,
- `autfilt`: reads automata (in the HOA format, the LBT's format or never claims), transform them, filter them, and output them (in the HOA format, the LBT's format, as never claims, or dot output for graphical display)
- `ltlcross`: compares and checks LTL/PSL translators (can read HOA, LBT, never claims, or ltl2dstar's output)
- `ltldo`: Wrap existing LTL to Büchi translator tools, providing them all the range of input and output Spot supports.  For instance running `ltldo spin -f GFa -H` will use [spin](http://spinroot.com/) to translate `[]<>a` and convert the result to the HOA format.

In these tools, HOA support is currently [limited to non-alternating automata](https://spot.lrde.epita.fr/hoa.html).  The implemented C++ parser supports streaming of automata, where the input can mix the HOA format, the LBT format and never claims.

Spot's source code is distributed under the [GNU General Public License, version 3](http://www.gnu.org/licenses/gpl-3.0.html).


## <a name="live-cd">Live CD</a>

You can obtain an [ISO image](http://wwwtcs.inf.tu-dresden.de/ALGI/TR/hoaf-livecd/hoaf-live.iso) (740MB, SHASUM: a23c47374b5a2ae7e31f9c9cb2d6908384c7cf29), containing a Debian Live CD with various tools preinstalled for your convenience. You can run it in a virtual machine or burn it on a DVD and boot from it.

### Running in a virtual machine

As virtual machine, we have tried [QEMU](http://wiki.qemu.org/Main_Page) and [VirtualBox](http://www.virtualbox.org/).

For VirtualBox, create a new virtual machine, attach the ISO image as a CD-drive and boot. For RAM, use at least 512MB, preferably 1GB.

With KVM/QEMU on a Linux system, you can start the Live CD with

    kvm -cdrom hoaf-live.iso -boot d -m 1024 -net nic -net user

or

    qemu-system-i386 -cdrom hoaf-live.iso -boot d -m 1024 -net nic -net user

depending on your installation, providing the virtual machine with 1GB of RAM. If you omit the `-net` parameters, the VM will not have a network connection, but everything else should work fine. For the latter command, if your kernel supports KVM and you have enabled hardware virtualization support in the BIOS, you can use `--enable-kvm` to get much better performance.


### Using the Live CD

After the initial boot, press Enter to boot the live system. When the boot process is completed, you can login to the graphical desktop, with username `hoaf` and password `hoaf`.

On the desktop, you will find links to the HOA format specification, a terminal and a [README file](http://wwwtcs.inf.tu-dresden.de/ALGI/TR/hoaf-livecd/README), suggesting example command-lines to try.

Note, that the keyboard layout is initially set to US. To change the keyboard layout to match the one on your computer, start the terminal and run

    setxkbmap lang

where `lang` is your language code, e.g., `de` for German, `fr` for French, ...

Enjoy!
