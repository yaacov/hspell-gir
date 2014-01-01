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

from word import Word

class Sentence:
    def __init__(self, hspell, sentense):
        '''
        '''
        
        # split our sentence to words, remove none word letters
        self.words_text = sentense.split();
        self.words = []
        
        # for each word get all its potential linguistic options
        i = 0
        for word in self.words_text:
            # check word for linguistic options
            word_options = Word(hspell, word, i)
            i += 1
            
            # add the word and its linguistic options to the words list
            self.words.append(word_options)
        
    def set_spell_hint_option(self, index, option_index, option_type, new_value):
        '''
        '''
        
        self.words[index].option_list[option_index].info[option_type] = new_value
    
    def get_spell_hint_option(self, index, option_index, option_type):
        '''
        '''
        
        return self.words[index].option_list[option_index].info[option_type]
    
    def get_spell_hint_options_len(self, index):
        '''
        '''
        
        return len(self.words[index].option_list)
        
    def to_string_words(self):
        '''
            print out the sentence word by word, with all the spelling ifno we have
        '''
        
        out_html = ""
        
        for word in self.words:
            # print all the option / corrections for this word
            out_html += "%s" % word.to_string()
            
            out_html += u"<br>"
        
        return out_html
        
