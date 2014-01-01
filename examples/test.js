#!/usr/bin/gjs

const Hspell = imports.gi.LibHspell.Hspell;
var h = Hspell.new();

var word;
var length;
var ans;

// test the spelling of a word
// ---------------------------
print ("\ncheck words:");

word = "שלום";
print (word, h.check_word(word));

// try to correct a misspelled word
// --------------------------------
print ("\ntrycorrect:");

word = "חטולים";
print (word, h.check_word(word));

length = h.trycorrect(word);
for (i = 0; i < length; i++) {
    ans = h.get_correction(i);
    print ("correction: ", ans, h.check_word(ans));
}

// try to split a word
// -------------------
print ("\nsplits:");

word = "וחתולים";
print (word);

length = h.enum_splits(word);
for (i = 0; i < length; i++) {
    ans = h.get_split(i);
    print ("split: ", ans, h.check_word(ans));
}

// try to get linguistic information
// ---------------------------------
print ("\nlinginfo:");

word = "הלכו";
print (word);

length = h.linginfo(word);
for (i = 0; i < length; i++) {
    print ("info: ", h.get_info_stem(i), h.get_info_desc(i));
    
    types = ["type","gender","person","number","tense","name","pronoun","construct"];
    for (let j in types) {
        print (types[j] + " - " + h.get_info(types[j], i));
    }
}
