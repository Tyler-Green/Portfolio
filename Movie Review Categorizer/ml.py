import argparse
import os
import re
import sys
import shutil
import nltk
import glob
import numpy as np
import pandas as pd
from random import shuffle
from collections import Counter
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer 
from nltk.tag.util import tuple2str
from nltk.tokenize import word_tokenize
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2
from sklearn.feature_selection import mutual_info_classif
from sklearn.model_selection import KFold
from sklearn import svm
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import f1_score

class FileReader:
	def setManager(self, manager):
		self.Manager = manager
	#method to loop through directory of files
	def read(self):
		path = os.path.join('txt_sentoken','Unprocessed','*','*')
		for file in glob.iglob(path, recursive=True):
			reader.readFile(file)
	#method to read file and send data to manager
	def readFile(self, fileName):
		file = open(fileName, 'r', encoding = 'ascii')
		line = file.readline()
		while line:
			self.Manager.add(line, fileName)
			line = file.readline()
		file.close()

class Analyser:
	def __init__(self, lang):
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
		for doc in self.docCntLine:
			print(f'Doc: {doc}')
			print(f'Lines: {self.docCntLine[doc]}')
			print(f'Tokens: {self.docCntToken[doc]}')
			avg = self.docCntToken[doc]/self.docCntLine[doc]
			print(f'Avg Sentence Length: {avg}')
		avg = sum(self.docCntToken)/sum(self.docCntLine)
		print(f'Collection Avg Sentence Length: {avg}')
		self.plotTokens()
		
class Preprocessing:
	@staticmethod
	def readCorpus():
		path = os.path.join('txt_sentoken','Unprocessed','*','*')
		devSet = open(os.path.join('txt_sentoken','devSet'), 'w', encoding = 'ascii')
		i = 0
		lines = []
		for file in glob.iglob(path, recursive=True):
			if i < 15:
				devSet.write(file)
				devSet.write('\n')
			else:
				lines.append(file)
			i = (i+1)%100
		devSet.close()
		shuffle(lines)
		workingSet = open(os.path.join('txt_sentoken','workingSet'), 'w', encoding = 'ascii')
		for line in lines:
			workingSet.write(line)
			workingSet.write('\n')
		workingSet.close()
		
		corpus = []
		workingSet = open(os.path.join('txt_sentoken','workingSet'), 'r', encoding = 'ascii')
		line = workingSet.readline().rstrip()
		while line:
			file = open(line, 'r', encoding = 'ascii')
			corpus.append(file.read())
			file.close()
			line = workingSet.readline().rstrip()
		workingSet.close()
		
		devSet = open(os.path.join('txt_sentoken','devSet'), 'r', encoding = 'ascii')
		line = devSet.readline().rstrip()
		while line:
			file = open(line, 'r', encoding = 'ascii')
			corpus.append(file.read())
			file.close()
			line = devSet.readline().rstrip()
		devSet.close()
		return corpus
		
	@staticmethod
	def GenerateY():
		y = []
		workingSet = open(os.path.join('txt_sentoken','workingSet'), 'r', encoding = 'ascii')
		line = workingSet.readline().rstrip()
		while line:
			if line.find('neg') >= 0:
				y.append(-1)
			else:
				y.append(1)
			line = workingSet.readline().rstrip()
		workingSet.close()
		
		devSet = open(os.path.join('txt_sentoken','devSet'), 'r', encoding = 'ascii')
		line = devSet.readline().rstrip()
		while line:
			if line.find('neg') >= 0:
				y.append(-1)
			else:
				y.append(1)
			line = devSet.readline().rstrip()
		devSet.close()
		return y
		
if __name__ == "__main__":
	#Set Up Cmd Line Args
	parser = argparse.ArgumentParser(description='A Program Design To Conduct A Machine Learning Method Comparison On Movie Review Classification')
	parser.add_argument("-a", "--Analysis", action="store_true", help="Conduct The Analysis")
	parser.add_argument("-f", "--Folds", default=5, type=int, help="How Many Folds To Use")
	args = parser.parse_args()
	analysis = args.Analysis
	numFolds = args.Folds
	
	if analysis:
		reader = FileReader()
		analyse = Analyser('english')
		reader.setManager(analyse)
		reader.read()
		analyse.analyse()
		sys.exit(1)
		
	#generating both result vector as well as the input matrice
	cv = CountVectorizer()
	corpus = Preprocessing.readCorpus()
	x = cv.fit_transform(corpus)
	train_x = x[0:1700]
	dev_x = x[1700:2000]
	y = Preprocessing.GenerateY()
	train_y = y[0:1700]
	dev_y = y[1700:2000]
	
	#feature selection methods of chi2 and anova f value for clasification models
	#both turn sparse data dense which is desirable as language data is very sparse
	#x_chi = SelectKBest(chi2, k=500).fit_transform(x, y)
	#x_f = SelectKBest(f_classif, k=500).fit_transform(x, y)
	
	#generate the folds as well as iterate through them
	bestModelOverall = None
	bestF1Overall = None
	bestSelectorOverall = None
	bestF1Overall = 0
	kf = KFold(n_splits=numFolds)
	for train_index, test_index in kf.split(train_x):
		bestModel = None
		bestF1 = 0
		transformed_X = None
		transformed_Y = None
		bestSelector = None
		#print("TRAIN:", train_index, "TEST:", test_index)
		for numFeatures in range(500,3001,500):
			selectors = [SelectKBest(chi2, k=numFeatures), SelectKBest(mutual_info_classif, k=numFeatures)]
			selector = SelectKBest(chi2, k=numFeatures)
			for selector in selectors:
				print(selector)
				selector.fit(train_x, train_y)
				x_chi = selector.transform(train_x)
				dev_x_chi = selector.transform(dev_x)
			
				x_working = np.empty(shape=(len(train_index),numFeatures)) 
				y_working = np.empty(shape=(len(train_index),)) 
			
				x_test = np.empty(shape=(len(test_index),numFeatures)) 
				y_test = np.empty(shape=(len(test_index),)) 
			
				x_dev = np.empty(shape=(300,numFeatures)) 
			
				for i in range(0,len(train_index)):
					for j in range(0,numFeatures):
						x_working[i,j] = x_chi[train_index[i],j]
					y_working[i] = train_y[train_index[i]]
				#print(x_working.shape)
			
				for i in range(0,len(test_index)):
					for j in range(0,numFeatures):
						x_test[i,j] = x_chi[test_index[i],j]
					y_test[i] = train_y[test_index[i]]
			
				for i in range(0,300):
					for j in range(0,numFeatures):
						x_dev[i,j] = dev_x_chi[i,j]
			
				#svm
				clf = svm.SVC(gamma='scale')
				clf.fit(x_working, y_working)
				prediction = clf.predict(x_dev)
				svcF = f1_score(dev_y, prediction, average='micro') 
				print(f'svc: ')
				print(svcF)
			
				#k nearest neighbours
				neigh = KNeighborsClassifier(n_neighbors=5)
				neigh.fit(x_working, y_working)
				prediction = neigh.predict(x_dev)
				neighF = f1_score(dev_y, prediction, average='micro') 
				print(f'neighbours: ')
				print(neighF)
			
				#niave bayes
				gnb = GaussianNB()
				gnb.fit(x_working, y_working)
				prediction = gnb.predict(x_dev)
				gnbF = f1_score(dev_y, prediction, average='micro') 
				print(f'gaussian NB: ')
				print(gnbF)
				
				if svcF > bestF1:
					bestModel = clf
					bestF1 = svcF
					transformed_X = x_test
					transformed_Y = y_test
					bestSelector = selector
				if neighF > bestF1:
					bestModel = neigh
					bestF1 = neighF
					transformed_X = x_test
					transformed_Y = y_test
					bestSelector = selector
				if gnbF > bestF1:
					bestModel = gnb
					bestF1 = gnbF
					transformed_X = x_test
					transformed_Y = y_test
					bestSelector = selector
		print('Best For Fold')
		print(bestModel)
		print(bestSelector)
		prediction = bestModel.predict(transformed_X)
		bestF1 = f1_score(transformed_Y, prediction, average='micro')
		print(bestF1)
		if bestF1 > bestF1Overall:
			bestModelOverall = bestModel
			bestSelectorOverall = bestSelector
			bestF1Overall = bestF1
	print('Best Overall')
	print(bestModelOverall)
	print(bestSelectorOverall)