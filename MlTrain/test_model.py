import coremltools

# Load the model
model =  coremltools.models.MLModel('Advertising.mlmodel')

# Make predictions
predictions = model.predict({'Daily Time Spent on Site': 30.0, 'Age': 30.0, 'Area Income': 70000, 'Daily Internet Usage': 200, 'Male': 0})

print(predictions)
