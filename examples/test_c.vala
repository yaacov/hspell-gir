/* test_c.vala
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
 * 	Yaacov Zamir <kobi.zamir@gmail.com>
 */
 
/* compile:
	valac --pkg hspell --pkg linginfo --pkg hspell-gir test_c.vala
 */

using HspellC;
using LinginfoC;

void main () {
	DictRadix *dict;
	int preflen;
	string word;
	string word_iso;
	
	init(out dict, 2);
	
	// hspell
	//--------------
	
	// check word
	word = "שלום";
	stdout.printf ("%s\n", word);
	word_iso = convert(word, -1, "iso-8859-8", "utf-8");
	stdout.printf ("%d\n", check_word(dict, word_iso, out preflen));
	
	word = "שלגום";
	stdout.printf ("%s\n", word);
	word_iso = convert(word, -1, "iso-8859-8", "utf-8");
	stdout.printf ("%d\n", check_word(dict, word_iso, out preflen));
	
	// try to correct
	Corlist cl = Corlist();
	corlist_init(&cl);
	trycorrect(dict, word_iso, &cl);

	stdout.printf ("%d\n", cl.n);

	for (int i = 0; i < cl.n; i++) {
		word = convert((string)(cl.correction[i]), -1, "utf-8", "iso-8859-8");
		stdout.printf ("%s\n", word);
	}
	
	corlist_free(&cl);
	
	// word splits
	//--------------
	word = "החתולים";
	stdout.printf ("%s\n", word);
	word_iso = convert(word, -1, "iso-8859-8", "utf-8");
	stdout.printf ("%d\n", check_word(dict, word_iso, out preflen));
	
	enum_splits(dict, word_iso, (w, bw, f, p) => 
		{
			string wu = convert(w, -1, "utf-8", "iso-8859-8");
			string bwu = convert(bw, -1, "utf-8", "iso-8859-8");
			stdout.printf("%s %s %d %d\n", wu, bwu, f, p);
			return 0;
		});
			
	// linginfo
	//--------------
	char * desc;
	char * stem;
	char[] output = new char[80];
	string ans;

	word = "שולחנות";
	stdout.printf ("%s\n", word);
	word_iso = convert(word, -1, "iso-8859-8", "utf-8");
	stdout.printf ("%d\n", check_word(dict, word_iso, out preflen));
	
	stdout.printf ("has info %d\n", linginfo_lookup(word_iso, out desc, out stem));
	ans = linginfo_stem2text(stem, 0);
	string stem_u = convert(ans, -1, "utf-8", "iso-8859-8");
	
	ans = linginfo_desc2text(output, desc, 0);
	string desc_u = convert(ans, -1, "utf-8", "iso-8859-8");
	
	stdout.printf ("%s\n", desc_u);
	stdout.printf ("%s\n", stem_u);
	
	uninit(dict);
}
