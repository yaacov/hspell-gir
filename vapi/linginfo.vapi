[CCode(cheader_filename = "linginfo.h", lower_case_cprefix = "linginfo_", cprefix = "")]
namespace LinginfoC {
	
	[CCode (cname = "linginfo_init")]
	public int linginfo_init(string dir);
	
	[CCode (cname = "linginfo_free")]
	public int linginfo_free();
	
	[CCode (cname = "linginfo_desc2text")]
	public unowned string linginfo_desc2text(char *text,char *desc, int i);
	
	[CCode (cname = "linginfo_desc2ps")]
	public int linginfo_desc2ps(char *desc, int i);
	
	[CCode (cname = "linginfo_stem2text")]
	public unowned string linginfo_stem2text(char *stem, int i);
	
	[CCode (cname = "linginfo_lookup")]
	public int linginfo_lookup(string word, out char *desc, out char *stem);
	
	[CCode (cname = "dcode2dmask")]
	static unowned int dcode2dmask(char *dcode);
}

