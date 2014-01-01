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

def check_grammer_function(sentence, sentence_length, index):
    ''' 
    hebrew description of this function:
    
    אם מילה מתחילה ב 'ו' והיא מאותו סוג כמו המילה הקודמת היא כניראה חיבור עם המילה הקודמת
    במידה והחיבור הוא של שמות עצם, צריך לשנות את רמז התחביר ל'רבים'
    '''
    
    # if this is the first word, it does not have a previos word - return
    if index == 0:
        return
    
    # get the prev word type
    prev_wtype = sentence.get_spell_hint('wtype', index - 1)
    
    # loop on all the spelling hints for this word:
    #   if they stat with vav and have the same type - ok
    #   if they do not stat with vav and have the same type - bad
    word_hint_options_len = sentence.get_spell_hint_options_len(index)
    
    for option_index in range(word_hint_options_len):
        prefix = sentence.get_spell_hint_option(index, option_index, 'prefix')
        wtype = sentence.get_spell_hint_option( index, option_index, 'wtype')
        
        if prev_wtype == wtype and not prefix.startswith(u'ו'):
            sentence.set_spell_hint_option(index, option_index, 'probability', -10)
    
    return True

grammer_rulls_array = [
    check_grammer_function,
]

