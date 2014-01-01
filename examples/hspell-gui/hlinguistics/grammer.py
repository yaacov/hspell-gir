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
from word import Word
from sentence import Sentence

class Grammer(Sentence):
    def __init__(self, hspell, sentence):
        '''
        '''
        
        Sentence.__init__(self, hspell, sentence)
        
        self.spell_hints = [None] * len(self.words)
        self.grammer_hints = [{'hint':'', 'construct':'', 'sentence_part':''}] * len(self.words)
    
    def set_spell_hint(self, info_type, index, info):
        '''
        '''
        
        self.spell_hints[index].info[info_type] = info
    
    def get_spell_hint(self, info_type, index):
        '''
        '''
        
        return self.spell_hints[index].info[info_type]
    
    def set_grammer_hint(self, info_type, index, info):
        '''
        '''
        
        self.grammer_hints[index][info_type] = info
    
    def get_grammer_hint(self, info_type, index):
        '''
        '''
        
        return self.grammer_hints[index][info_type]
        
    def relax_spell_hints(self, word_index = None):
        ''' 
            if a word has only one posible reading option, 
            remmember this reading option as a spell hint
        '''
        
        if word_index == None:
            word_list = self.words
        else:
            word_list = [self.words[word_index],]
            
        # if a word has only one reading option, it has to be the right one (?)
        for word in word_list:
            if len(word.option_list) == 1:
                self.spell_hints[word.index] = word.option_list[0]
            else:
                self.spell_hints[word.index] = WordInfo(word.word, word.index)
                
        # check if a word has only one info_type, with good probability
        # pass this info_type to the spelling hint
        info_types = ['wtype','tense','number','gender','prefix','split',
            'person','name','pronoun','construct','stem']
        
        for info_type in info_types:
            for word in word_list:
                if len(word.option_list) > 1:
                    only_one = True
                    info = word.option_list[0].info[info_type]
                    for option in word.option_list:
                        if info != option.info[info_type] and option.info['probability'] > 0:
                            only_one = False
                            
                    if only_one:
                        self.spell_hints[word.index].info[info_type] = info
    
    def to_string_words(self):
        '''
            print out the sentence word by word, with all the spelling and
            grammer ifno we have
        '''
        
        out_html = ""
        
        for word in self.words:
            # print all the option / corrections for this word
            out_html += "%s" % word.to_string()
            
            # print the spelling hints
            ans = self.spell_hints[word.index].to_string_word()
            info = self.spell_hints[word.index].to_string_info()
            
            out_html += u".    רמז לניתוח: <span style='color:orange;'>%s: %s</span><br>" % (ans, info)
            
            # print the grammer hints
            
            # add a new lint at the end of a word
            out_html += u"<br>"
        
        return out_html
    
    def check_grammer(self, check_grammer_function):
        '''
            try to guess grammer hints about this sentence using
            a function that checks grammer,
            we run this function in a loop on each word in the
            sentence, one by one
        '''
        # get number of words in sentence
        sentence = self
        sentence_length = len(self.words)
        
        # search for absulute word info
        self.relax_spell_hints()
        
        # do grammer checks
        index = 0
        continue_to_next_word = True
        
        # run the check_grammer_function on all the words in the sentence
        while index < sentence_length and continue_to_next_word:
            check_grammer_function(sentence, sentence_length, index)
            
            # re-search for absulute spell hints
            self.relax_spell_hints(index)
            
            index += 1
        


