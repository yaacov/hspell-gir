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

class WordInfo:
    def __init__(self, word, index,
            prefix = "", split = "", wtype = "", 
            gender = "", person = "", 
            number = "", tense = "",
            name = "", pronoun = "",
            construct = "",
            stem = "", desc = ""):
        
        self.index = index
        
        self.info = locals()
        self.info['probability'] = 1
        
    def to_string_word(self):
        '''
        '''
        
        if (self.info['prefix'] == ""):
            return self.info['word']
        else:
            return "%s+%s" % (self.info['prefix'], self.info['split'])
        
    def to_string_info(self):
        '''
        '''
        
        info_dict = self.info
        
        html_output = "%s - " % (info_dict['stem'])
        
        if info_dict['wtype'] == 'noun':
            html_output += u"שם עצם"
        elif info_dict['wtype'] == 'verb':
            html_output += u"פועל"
        elif info_dict['wtype'] == 'adj':
            html_output += u"תאור"
        else:
            html_output += "x"
        
        if info_dict['gender'] == 'masculine':
            html_output += u", זכר"
        elif info_dict['gender'] == 'feminine':
            html_output += u", נקבה"
        
        if info_dict['person'] == "1'st":
            html_output += u", גוף ראשון"
        elif info_dict['person'] == "2'nd":
            html_output += u", גוף שני"
        elif info_dict['person'] == "3'rd":
            html_output += u", גוף שלישי"
            
        if info_dict['number'] == "singular":
            html_output += u" יחיד"
        elif info_dict['number'] == "double":
            html_output += u" זוג"
        elif info_dict['number'] == "plural":
            html_output += u" רבים"
            
        if info_dict['tense'] == "past":
            html_output += u", עבר"
        elif info_dict['tense'] == "present":
            html_output += u", הווה"
        elif info_dict['tense'] == "future":
            html_output += u", עתיד"
        elif info_dict['tense'] == "imperative":
            html_output += u", ציווי"
        elif info_dict['tense'] == "infinitive":
            html_output += u", מקור"
        elif info_dict['tense'] == "b. infinitive":
            html_output += u", מקור שני"
        
        if info_dict['name'] == "name":
            html_output += u", פרטי"
        if info_dict['pronoun'] == "pronoun":
            html_output += u", כינוי"
        if info_dict['construct'] == "construct":
            html_output += u", סמיכות"
        
        html_output += u" ,%d" % info_dict['probability']
        
        return html_output

