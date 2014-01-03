hspell-gir
==========

hspell gobject wrapper

A GObject wrapper class for Hspell
----------------------------------

The Hspell project is a free Hebrew linguistic project. http://hspell.ivrix.org.il

GObject introspection project is a convenient bridge between code libraries written in different languages. http://live.gnome.org/GObjectIntrospection

The hspell-gir project goal is to make it easy to use the Hspell C library with different languages and toolkits.

Examples
--------
The GObject introspection can be used in many languages:

A Java script example:
[test.js](http://code.google.com/p/hspell-gir/source/browse/examples/test.js) 

A Python example:
[test.py](http://code.google.com/p/hspell-gir/source/browse/examples/test.py) 

Graphical example using Python and Qt
-------------------------------------

A pyside example:
[hspell-gui.py](http://code.google.com/p/hspell-gir/source/browse/examples/hspell-gui/hspell-gui.py)

<img src="https://raw.github.com/yaacov/hspell-gir/master/examples/images/hspell.png" width="350" height="400" >

Usage
-----

Check if a word is misspelled: 

    from gi.repository.LibHspell import Hspell
    h = Hspell.new();
    
    word = "שלום"
    print word, h.check_word(word)


Check if a word is noun or adjactive, and get it's gender: 

    from gi.repository.LibHspell import Hspell
    h = Hspell.new();
    
    word = "חתולים"
    length = h.linginfo(word)
    for i in range(length):
        print word, h.get_info("type", i), h.get_info("gender", i)


Check a word tense: 

    from gi.repository.LibHspell import Hspell
    h = Hspell.new();
    
    word = "הלכו"
    length = h.linginfo(word)
    for i in range(length):
        print word, h.get_info("tense", i)

