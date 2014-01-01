/* hdate-glib.vala
 *
 * Copyright (C) 2010, 2011  Yaacov Zamir
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
 *     Yaacov Zamir <kobi.zamir@gmail.com>
 */

using GLib;
using HspellC;
using LinginfoC;

namespace LibHspell {
    public class Hspell : Object {
        
        private DictRadix *dict;
        
        public string[] correction_list;
        public string[] split_list;
        public Linginfo info;
        
        public Hspell() {
            word_split_list = new string[30];
            info = new Linginfo();
            
            init(out dict, 2);
        }
        
        ~Hspell() {
            uninit(dict);
        }
        
        /** check a word spelling
         *
         * @param word a word to check
         * @return true if word speled correctly false o/w
         */
        public bool check_word(string word) {
            int preflen;
            string word_iso = convert_to_iso(word);
            int output = HspellC.check_word(dict, word_iso, out preflen);
            
            return (output == 1);
        }
        
        /** process a word for for corections and lingual information
         *
         * @param word a word to check
         * @return true
         */
        public bool process_word(string word) {
            
            trycorrect(word);
            enum_splits(word);
            linginfo(word);
            
            return true;
        }
        
        /** get the length of the correction list
         *
         * @return the length of the correction list
         */
        public int get_correction_len() { return correction_list.length; }
        
        /** get the length of the word splits list
         *
         * @return the length of the  word splits list
         */
        public int get_split_len() { return split_list.length; }
        
        /** get the length of the word information list
         *
         * @return the length of the word information list
         */
        public int get_info_len() { return info.len; }
        
        /** get the i'th correction in the correction list
         *
         * @return the i'th correction in the correction list
         */
        public unowned string get_correction(int i) { return correction_list[i]; }
        
        /** get the i'th split in the split list
         *
         * @return the i'th split in the split list
         */
        public unowned string get_split(int i) { return split_list[i]; }
        
        /** get the i'th desc in the info list
         *
         * @return the i'th desc in the info list
         */
        public unowned string get_info_desc(int i) { return info.get_desc(i); }
        
        /** get the i'th stem in the info list
         *
         * @return the i'th stem in the info list
         */
        public unowned string get_info_stem(int i) { return info.get_stem(i); }
        
        /** get the i'th item in the info list lingual information
         *
         * @param type a lingual information type:
         *              type - noun, verb, adj ...
         *              gender -
         *              person - 1st, 2nd, 3rd
         *              number -
         *              tense -
         *              name -
         *              pronoun -
         *              construct -
         *
         * @return the i'th item in the info list lingual information
         */
        public string get_info(string type, int i) { 
            string output = "";
            int dmask;
            
            if (info.desc[i*2] == 0) 
                return output;
            
            // FIXME: we need to use - dcode2dmask(info.desc + i * 2)
            //  but the compiler say it is not in libhspell.a !?
            int index = info.desc[i*2] - 'A' + (info.desc[i*2 + 1] - 'A') * 26;
            dmask = dmasks[index];
            
            switch (type) {
            case "type":
                switch(dmask & D.TYPEMASK) {
                case D.NOUN: 
                    output = "noun"; 
                    break;
                case D.VERB: 
                    output = "verb"; 
                    break;
                case D.ADJ: 
                    output = "adj"; 
                    break;
                default: 
                    output = "none";
                    break;
                }
                break;
            case "gender":
                if ((dmask & D.GENDERMASK & D.MASCULINE) != 0)
                    output = "masculine";
                else if ((dmask & D.GENDERMASK & D.FEMININE) != 0)
                    output = "feminine";
                else
                    output = "none";
                break;
            case "person":
                switch(dmask & D.GUFMASK) {
                case D.FIRST: 
                    output = "1'st"; 
                    break;
                case D.SECOND: 
                    output = "2'nd"; 
                    break;
                case D.THIRD: 
                    output = "3'rd"; 
                    break;
                default: 
                    output = "none";
                    break;
                }
                break;
            case "number":
                switch(dmask & D.NUMMASK) {
                case D.SINGULAR: 
                    output = "singular"; 
                    break;
                case D.DOUBLE: 
                    output = "double"; 
                    break;
                case D.PLURAL: 
                    output = "plural"; 
                    break;
                default: 
                    output = "none";
                    break;
                }
                break;
            case "tense":
                switch(dmask & D.TENSEMASK) {
                case D.PAST: 
                    output = "past"; 
                    break;
                case D.PRESENT: 
                    output = "present"; 
                    break;
                case D.FUTURE: 
                    output = "future"; 
                    break;
                case D.IMPERATIVE: 
                    output = "imperative"; 
                    break;
                case D.INFINITIVE: 
                    output = "infinitive"; 
                    break;
                case D.BINFINITIVE: 
                    output = "b. infinitive"; 
                    break;
                default: 
                    output = "none";
                    break;
                }
                break;
            case "name":
                if ((dmask & D.SPECNOUN) != 0) 
                    output = "name";
                else
                    output = "none";
                break;
            case "pronoun":
                if ((dmask & D.OMASK) != 0) 
                    output = "pronoun";
                else
                    output = "none";
                break;
            case "construct":
                if ((dmask & D.OSMICHUT) != 0) 
                    output = "construct";
                else
                    output = "none";
                break;
            }
            
            return output;
        }
        
        public int trycorrect(string word) {
            string word_iso = convert_to_iso(word);
            Corlist cl = Corlist();
            int len;
            
            corlist_init(&cl);
            
            HspellC.trycorrect(dict, word_iso, &cl);
            len = cl.n;
            
            correction_list = new string[len];
            for (int i = 0; i < len; i++) {
                correction_list[i] = convert_to_utf((string)(cl.correction[i]));
            }
            corlist_free(&cl);
            
            return len;
        }
            
        public int enum_splits(string word) {
            string word_iso = convert_to_iso(word);
            
            word_split_list_len = 0;
            HspellC.enum_splits(dict, word_iso, word_split_func);
            
            split_list = word_split_list[0:word_split_list_len];
            
            return word_split_list_len;
        }
        
        public int linginfo(string word) {
            string ans;
            char[] ans_output = new char[80];
            string word_iso = convert_to_iso(word);
            
            // try to get linginfo
            if (linginfo_lookup(word_iso, out info.desc, out info.stem) == 1) {
                
                // get length
                for (info.len = 0; info.len < 256; info.len++)
                    if (info.desc[info.len*2]==0) break;
                
                // get texts
                info.stem_txt = new string[info.len];
                info.desc_txt = new string[info.len];
                
                for (int i = 0; i < info.len; i++) {
                    ans = linginfo_stem2text(info.stem, i);
                    info.stem_txt[i] = convert_to_utf(ans);
    
                    ans = linginfo_desc2text(ans_output, info.desc, i);
                    info.desc_txt[i] = convert_to_utf(ans);
                }
            }
            
            return info.len;
        }
    }
    
    public class Linginfo : Object {
        public Linginfo() {
            len = 0;
        }
        
        public char * desc;
        public char * stem;
        
        public string[] desc_txt;
        public string[] stem_txt;
        
        public int len;
        
        public int get_desc_len() { return desc_txt.length; }
        public int get_stem_len() { return stem_txt.length; }
        public unowned string get_desc(int i) { return desc_txt[i]; }
        public unowned string get_stem(int i) { return stem_txt[i]; }
    }
    
    // FIXME: we can only use this class once
    private string[] word_split_list;
    private int word_split_list_len;
    private int word_split_func (string word, 
            string baseword, int preflen, int prefspec) {
        word_split_list[word_split_list_len] = convert_to_utf(baseword);
        word_split_list_len++;
        return 0;
    }
    
    private string convert_to_utf(string word) {
        string output = "";
        
        try {
            output = convert(word, -1, "utf-8", "iso-8859-8");
        } catch {
            output = "";
        }
        
        return output;
    }
    
    private string convert_to_iso(string word) {
        string output = "";
        
        try {
            output = convert(word, -1, "iso-8859-8", "utf-8");
        } catch {
            output = "";
        }
        
        return output;
    }
    
    // FIXME: this is only good for the word list in hspell-1.1
    //  we need to use dcode2dmask function and remove this array
    private const int dmasks[] = {
        69,
        131141,
        41029,
        106565,
        51269,
        53317,
        116805,
        118853,
        59461,
        61509,
        127045,
        124997,
        197,
        131269,
        41157,
        106693,
        51397,
        53445,
        116933,
        118981,
        59589,
        61637,
        127173,
        125125,
        73,
        131145,
        41033,
        106569,
        51273,
        53321,
        116809,
        118857,
        59465,
        61513,
        127049,
        125001,
        201,
        131273,
        41161,
        106697,
        51401,
        53449,
        116937,
        118985,
        59593,
        61641,
        127177,
        125129,
        71,
        131143,
        199,
        131271,
        75,
        131147,
        203,
        131275,
        77,
        131149,
        41037,
        106573,
        51277,
        53325,
        116813,
        118861,
        59469,
        61517,
        127053,
        125005,
        205,
        131277,
        41165,
        106701,
        51405,
        53453,
        116941,
        118989,
        59597,
        61645,
        127181,
        125133,
        262153,
        630,
        594,
        614,
        618,
        634,
        722,
        742,
        746,
        758,
        762,
        258,
        41218,
        51458,
        53506,
        59650,
        61698,
        106754,
        116994,
        119042,
        125186,
        127234,
        42498,
        1382,
        1386,
        1510,
        1514,
        1106,
        1126,
        1130,
        1142,
        1146,
        1234,
        1254,
        1258,
        1270,
        1274,
        838,
        131910,
        842,
        131914,
        966,
        132038,
        970,
        132042,
        52738,
        60930,
        62978,
        108034,
        118274,
        120322,
        126466,
        128514,
        1538,
        0,
        67,
        65,
        2,
        262145,
        262149,
        262213,
        1,
        193,
        5,
        131137,
        262209,
        131073,
        3,
        834,
        770,
        962,
        131906,
        131842,
        132034
    };
    
    private enum D {
        NOUN = 1,
        VERB = 2,
        ADJ = 3,
        TYPEMASK = 3,
        GENDERBASE = 4,
        MASCULINE = 4,
        FEMININE = 8,
        GENDERMASK = 12,
        GUFBASE = 16,
        FIRST = 16,
        SECOND = 32,
        THIRD = 48,
        GUFMASK = 48,
        NUMBASE = 64,
        SINGULAR = 64,
        DOUBLE = 128,
        PLURAL = 192,
        NUMMASK = 192,
        TENSEBASE = 256,
        INFINITIVE = 256,
        BINFINITIVE = 1536,
        PAST = 512,
        PRESENT = 768,
        FUTURE = 1024,
        IMPERATIVE = 1280,
        TENSEMASK = 1792,
        OGENDERBASE = 2048,
        OMASCULINE = 2048,
        OFEMININE = 4096,
        OGENDERMASK = 6144,
        OGUFBASE = 8192,
        OFIRST = 8192,
        OSECOND = 16384,
        OTHIRD = 24576,
        OGUFMASK = 24576,
        ONUMBASE = 32768,
        OSINGULAR = 32768,
        ODOUBLE = 65536,
        OPLURAL = 98304,
        ONUMMASK = 98304,
        OMASK = 129024,
        OSMICHUT = 131072,
        SPECNOUN = 262144,
        STARTBIT = 524288
    }
}
