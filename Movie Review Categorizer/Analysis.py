# -*- coding: utf-8 -*-
#!/usr/bin/env python3
"""
Created on 2019-11-12

@author: Tyler Green
"""

#add cnts for sentence
#add cnts for doc nums
#add cnt for words in doc

import re
import os
import glob
import shutil
import nltk
import argparse
from collections import Counter
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer 
from nltk.tag.util import tuple2str
from nltk.tokenize import word_tokenize

#class for reading files in
class FileReader:
	def __init__(self):
		print(f'Initializing File Reader')
	#method to change the managing system
	def setManager(self, manager):
		print(f'Setting A New Manager')
		self.Manager = manager
	#method to loop through directory of files
	def read(self):
		print(f'Reading Files In')
		path = os.path.join('txt_sentoken','Unprocessed','*','*')
		for file in glob.iglob(path, recursive=True):
			reader.readFile(file)
	#method to read file and send data to manager
	def readFile(self, fileName):
		print(f'Reading File: {fileName}')
		file = open(fileName, 'r', encoding = 'ascii')
		line = file.readline()
		while line:
			self.Manager.add(line, fileName)
			line = file.readline()
		file.close()
#manager class for preprocessing	
class Preprocessor:
	def __init__(self, lang):
		print(f'Initializing Preprocessor')
		print(f'Setting Language To: {lang}')
		self.lang = lang
	#method for cleaning directory of processed files
	def clean(self):
		print(f'Cleaning The Processed Files')
		try:
			shutil.rmtree(os.path.join('txt_sentoken', 'Processed'))
		except:
			print(f'Unable To Clean Processed Files')
		os.mkdir(os.path.join('txt_sentoken', 'Processed'), 0o777)
		os.mkdir(os.path.join('txt_sentoken', 'Processed', 'neg'), 0o777)
		os.mkdir(os.path.join('txt_sentoken', 'Processed', 'pos'), 0o777)
	#method for creating files with the stemmed and tagged text
	def add(self, line, fileName):
		fileNameSplit = fileName.split(os.path.sep, 2)
		processFile = open(os.path.join('txt_sentoken','Processed',fileNameSplit[-1]), 'a+', encoding = 'ascii')
		#sw = stopwords.words(self.lang)
		ps = PorterStemmer()
		pattern = re.compile(".+[a-z].+")
		for word in word_tokenize(line):
			#if word not in sw and pattern.match(word):
			word = ps.stem(word)
			#processFile.write(tuple2str(nltk.pos_tag([word])[-1]))
			processFile.write(word)
			processFile.write(' ')
		processFile.write('\n')
		processFile.close()
#manager class for conducting the analysis
class Analyser:
	def __init__(self, lang):
		print(f'Initializing Analyser')
		print(f'Setting Language To: {lang}')
		self.lang = lang
		self.tokens = Counter() #list of all tokens
		self.stopTokens = Counter() #list of all stopwords
		self.docCntLine = Counter() #lines per doc
		self.docCntToken = Counter() #tokens per doc
	#class for adding text to the counters
	def add(self, text, fileName):
		sw = stopwords.words(self.lang)
		ps = PorterStemmer()
		pattern = re.compile(".+[a-z].+")
		words = word_tokenize(text)
		#increment value counters
		self.docCntLine[fileName]+=1
		self.docCntToken[fileName]+=len(words)
		#add tokens to appropriate list
		for word in words:
			if word not in sw and pattern.match(word):
				word = ps.stem(word)
				self.tokens[word]+=1
			else:
				self.stopTokens[word]+=1
	#method for plotting tokens based on freq		
	def plotTokens(self):
		print(f'Plotting Frequency Distribution')
		freq = nltk.FreqDist(self.tokens)
		freq.plot(30, cumulative=False)
	#method to display analysis and conduct math
	def analyse(self):
		print(f'Language: {self.lang}')
		tokCnt = sum(self.tokens.values())
		stopCnt = sum(self.stopTokens.values())
		lineCnt = sum(self.docCntLine.values())
		docCnt = len(list(self.docCntLine))
		totCnt = tokCnt + stopCnt
		avgLineLen = totCnt/lineCnt
		avgDocLine = lineCnt/docCnt
		avgDocTok = totCnt/docCnt
		print(f'Total Number of Lines: {lineCnt}')
		print(f'Total Number Of Tokens: {totCnt}')
		print(f'Number Of Stop Words: {stopCnt}')
		print(f'Number Of Tokens: {tokCnt}')
		print(f'Number of Docs: {docCnt}')
		print(f'Avg Line Length: {avgLineLen}')
		print(f'Avg Lines per Doc: {avgDocLine}')
		print(f'Avg Tokens per Doc: {avgDocTok}')
		print(f'Longest Doc by Line: {self.docCntLine.most_common()[1]}')
		print(f'Shortest Doc by Line: {self.docCntLine.most_common()[-1]}')
		print(f'Longest Doc by Tokens: {self.docCntToken.most_common()[1]}')
		print(f'Shortest Doc by Tokens: {self.docCntToken.most_common()[-1]}')
		self.plotTokens()
	
if __name__ == "__main__":
	#Set Up Cmd Line Args
	parser = argparse.ArgumentParser(description='A Program Design To Conduct Data Analysis As Well As Basic Data Preprocessing')
	parser.add_argument("-a", "--Analysis", action="store_true", help="Conduct The Analysis")
	parser.add_argument("-p", "--Preprocess", action="store_true", help="Preprocess The Data With Tags")
	#Parse Cmd Line Args
	args = parser.parse_args()
	a = args.Analysis
	p = args.Preprocess
	reader = FileReader()
	#conduct preprocess if arg given
	if p:
		preprocess = Preprocessor('english')
		preprocess.clean()
		reader.setManager(preprocess)
		reader.read()
	#conduct analysis if arg given
	if a:
		analyse = Analyser('english')
		reader.setManager(analyse)
		reader.read()
		analyse.analyse()