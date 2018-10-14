import pandas as pd 
import coremltools 
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

ad_data = pd.read_csv('advertising.csv')

X = ad_data[['Daily Time Spent on Site', 'Age', 'Area Income','Daily Internet Usage', 'Male']]
y = ad_data['Clicked on Ad']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)

logmodel = LogisticRegression()
logmodel.fit(X_train, y_train)

coreml_model = coremltools.converters.sklearn.convert(logmodel,
                                                      ['Daily Time Spent on Site', 'Age', 'Area Income','Daily Internet Usage', 'Male'],
                                                      'Clicked on Ad')

# Set model metadata
coreml_model.author = 'Kevvin Chen'
coreml_model.license = 'BSD'
coreml_model.short_description = 'Predicts if a user will click on an ad'

# Set feature descriptions manually
coreml_model.input_description['Daily Time Spent on Site'] = 'Daily Time Spent on Site'
coreml_model.input_description['Age'] = 'How old the person is'

# Set the output descriptions
coreml_model.output_description['Clicked on Ad'] = 'Will the user click an ad, 0 (no), y (yes)'

coreml_model.save('Advertising.mlmodel')
