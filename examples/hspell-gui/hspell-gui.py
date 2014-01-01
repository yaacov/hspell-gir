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

import sys

from PySide.QtGui import QApplication
from PySide.QtUiTools import QUiLoader

from gi.repository.LibHspell import Hspell

from hlinguistics.grammer import Grammer
from grammer_rulls.grammer_rulls import grammer_rulls_array

class HspellGui:
    def __init__(self):
        self.h = Hspell.new();
        self.ui = None
    
    def main(self, argv=None):
        
        if argv is None:
            argv = sys.argv

        app = QApplication(argv)

        loader = QUiLoader()
        self.ui = loader.load('./ui/hspell-gui.ui')

        self.ui.pushButton.clicked.connect(self.on_check)
        self.ui.show()
        
        return app.exec_()
        
    def on_check(self):
        
        # clear the results board
        self.ui.textEdit_2.setHtml('')
        
        # split our sentence to words, remove none word letters
        sentence_text = self.ui.textEdit.toPlainText()
        sentence = Grammer(self.h, sentence_text)
        
        # run the grammer checking functions
        for grammer_rull_function in grammer_rulls_array:
            sentence.check_grammer(grammer_rull_function)
        
        # for each word print all its potential linguistic options
        self.ui.textEdit_2.insertHtml(sentence.to_string_words())
        
if __name__ == '__main__':
    hspell_gui = HspellGui()
    
    hspell_gui.main()

