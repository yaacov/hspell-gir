#!/usr/bin/env python
# -*- coding:utf-8 -*-

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# Copyright (C) 2011 Yaacov Zamir (2011) <kobi.zamir@gmail.com>
# Authors: 
#    Yaacov Zamir (2011) <kobi.zamir@gmail.com>

from word_info import WordInfo

class Word:
    def __init__(self, hspell, word, index):
        self.hspell = hspell
        self.word = word
        self.index = index
        
        self.is_correct = hspell.check_word(word)
        
        # lists of WordInfo objects
        # evry word can have several word_info spelling options
        self.option_list = []
        self.correction_list = []
        
        # fill in the word info lists
        if self.is_correct:
            self.fill_option_list()
        else:
            self.fill_corection_list()
    
    def fill_corection_list(self):
        ''' get all the posible spelling corections for a word
        '''
        h = self.hspell
        word = self.word
        
        # get all the possible corrections
        length = h.trycorrect(word)
        i = 0
        for i in range(length):
            correction = unicode(h.get_correction(i), "utf-8")
            option = WordInfo(correction, i)
            i += 1
            
            self.correction_list.append(option)
    
    def fill_option_list(self):
        ''' get all the posible spelling information for a word
        '''
        h = self.hspell
        word = self.word
        
        # get optional splits
        length = h.enum_splits(word)
        splits = []
        for i in range(length):
            ans = unicode(h.get_split(i), "utf-8")
            l = len(ans)
            splits.append([word[:-l], word[-l:]])
        
        # for each split we found
        i = 0
        for prefix, split in splits:
            # get a list of linguistic info options
            length = h.linginfo(split)
            for i in range(length):
                stem = unicode(h.get_info_stem(i), "utf-8")
                desc = unicode(h.get_info_desc(i), "utf-8")
                wtype = unicode(h.get_info("type", i), "utf-8")
                gender = unicode(h.get_info("gender", i), "utf-8")
                person = unicode(h.get_info("person", i), "utf-8")
                number = unicode(h.get_info("number", i), "utf-8")
                tense = unicode(h.get_info("tense", i), "utf-8")
                name = unicode(h.get_info("name", i), "utf-8")
                pronoun = unicode(h.get_info("pronoun", i), "utf-8")
                construct = unicode(h.get_info("construct", i), "utf-8")
                
                # add the linguistic info to the list
                option = WordInfo(word, i,
                    prefix = prefix, split = split, wtype = wtype, 
                    gender = gender, person = person, 
                    number = number, tense = tense,
                    name = name, pronoun = pronoun,
                    construct = construct,
                    stem = stem, desc = desc)
                i += 1
                
                self.option_list.append(option)
    
    def to_string(self):
        '''
            print out the word, with all the spelling ifno we have
        '''
        
        word = self.word
        html_output = ""
        
        if self.is_correct:
            html_output += u"מילה חוקית: <span style='color:green;'>%s</span><br>" % word
            
            for option in self.option_list:
                ans = option.to_string_word()
                info = option.to_string_info()
                html_output +=  u".    ניתוח אפשרי: <span style='color:blue;'>%s: %s</span><br>" % (ans, info)
        else:
            html_output += u"מילה שגויה: <span style='color:red;'>%s</span><br>" % word
            
            for corection in self.correction_list:
                ans = corection.to_string_word()
                html_output +=  u".   הצעה לתיקון: <span style='color:blue;'>%s</span><br>" % ans
        
        return html_output

