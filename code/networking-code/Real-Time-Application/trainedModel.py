#!/usr/bin/python 

# Author: Thomas Roethenbaugh
# Date: 04/04/2025
# Version: 1.0
# This file is based on the inspect file given to me by Muhammad

import numpy as np
import pandas as pd
import joblib

from sklearn import datasets
#from sklearn.cross_validation import train_test_split
from sklearn.model_selection import train_test_split


data = pd.read_csv('packetChunk.csv')
loadedModel = joblib.load('trainedCustomModel.pkl')
result = loadedModel.predict(data)
prediction = result[0]

writeResult = open("isddos.txt", "w")
writeResult.write(str(prediction))
#with open('isddos.txt', 'rb') as f:
