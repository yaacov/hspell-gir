[CCode(cheader_filename = "hspell.h", lower_case_cprefix = "hspell_", cprefix = "")]
namespace HspellC {
		[CCode (cname = "hspell_word_split_callback_func", has_target = false)]
		public delegate int word_split_callback_func (string word,
			string baseword, int preflen, int prefspec);
		
		[CCode (cname = "struct corlist", destroy_function = "")]
		public struct Corlist {
			public char** correction; 
			public int n;
		}
		
		[CCode (cname = "corlist_add")]
		public int corlist_add(Corlist *cl, string s);
		
		[CCode (cname = "corlist_init")]
		public int corlist_init(Corlist *cl);
		
		[CCode (cname = "corlist_free")]
		public int corlist_free(Corlist *cl);
		
		[SimpleType]
		[CCode (cname = "struct dict_radix")]
		public struct DictRadix {}
		
		[CCode (cname = "hspell_init")]
		public int init(out DictRadix* dict, int flags);
		
		[CCode (cname = "hspell_check_word")]
		public int check_word(DictRadix* dict, string word, out int preflen);
		
		[CCode (cname = "hspell_trycorrect")]
		public void trycorrect(DictRadix* dict, string w, Corlist *cl);
		
		[CCode (cname = "hspell_is_canonic_gimatria")]
		public int is_canonic_gimatria(string w);
		
		[CCode (cname = "hspell_uninit")]
		public void uninit(DictRadix* dict);
		
		[CCode (cname = "hspell_get_dictionary_path")]
		public string get_dictionary_path();
		
		[CCode (cname = "hspell_set_dictionary_path")]
		public void set_dictionary_path(string path);
		
		[CCode (cname = "hspell_enum_splits")]
		public int enum_splits(DictRadix* dict, string word, 
			word_split_callback_func enumf);
	
}

