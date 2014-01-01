#!/usr/bin/python
# -*- coding: utf-8 -*-

from gi.repository.LibHspell import Hspell
h = Hspell.new();

# test the spelling of a word
# ---------------------------
print "\ncheck words:"

word = "שלום"
print word, h.check_word(word)

# try to correct a misspelled word
# --------------------------------
print "\ntrycorrect:"

word = "חטולים"
print word, h.check_word(word)

length = h.trycorrect(word)
for i in range(length):
    ans = h.get_correction(i)
    print "correction: ", ans, h.check_word(ans)

# try to split a word
# -------------------
print "\nsplits:"

word = "וחתולים"
print word

length = h.enum_splits(word)
for i in range(length):
    ans = h.get_split(i)
    print "split: ", ans, h.check_word(ans)

# try to get linguistic information
# ---------------------------------
print "\nlinginfo:"

word = "חתולים"
print word

length = h.linginfo(word)
for i in range(length):
    print "info: ", h.info.get_stem(i), h.info.get_desc(i)

    types = ["type","gender","person","number","tense","name","pronoun","construct"]
    for t in types:
        print t + " - " + h.get_info(t, i)

