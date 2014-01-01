/* test.vala
 *
 * Copyright (C) 2010  Yaacov Zamir
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *  Yaacov Zamir <kobi.zamir@gmail.com>
 */
 
/* compile:
    valac --pkg hspell --pkg linginfo --pkg hspell-gir test.vala
 */

using LibHspell;

void main () {
    Hspell h = new Hspell();
    string word;

    // test the spelling of a word
    // ---------------------------
    stdout.printf ("\ncheck words:\n");

    word = "שלום";
    stdout.printf ("%s %s\n", word, h.check_word(word).to_string());

    // try to correct a misspelled word
    // --------------------------------
    stdout.printf ("\ntrycorrect:\n");

    word = "חטולים";
    stdout.printf ("%s %s\n", word, h.check_word(word).to_string());

    h.trycorrect(word);
    foreach (string ans in h.correction_list) {
        stdout.printf ("correction: %s %s\n", ans, h.check_word(ans).to_string());
    }

    // try to split a word
    // -------------------
    stdout.printf ("\nsplits:\n");

    word = "וחתולים";
    stdout.printf ("%s %s\n", word, h.check_word(word).to_string());

    h.enum_splits(word);
    foreach (string split in h.split_list) {
        stdout.printf ("split: %s %s\n", split, h.check_word(split).to_string());
    }

    // try to get linguistic information
    // ---------------------------------
    stdout.printf ("\nlinginfo:\n");

    word = "חתולים";
    stdout.printf ("%s %s\n", word, h.check_word(word).to_string());

    h.linginfo(word);
    for (int i = 0; i < h.info.len; i++) {
        stdout.printf ("info %s %s\n", h.info.stem_txt[i], h.info.desc_txt[i]);
        
        string[] types = {"type","gender","person","number","tense","name","pronoun","construct"};
        foreach (string t in types) {
             stdout.printf ("%s - %s\n", t, h.get_info(t, i));
        }
    }
}
