import tensorflow as tf
import numpy as np
import pandas as pd
from transformers import BertTokenizer
from tensorflow import keras
from AImodel.transfomer import TransformerLayer

# Load the model

model = keras.models.load_model(
    'AImodel/my_model_doctor_final.h5',
    custom_objects={'TransformerLayer': TransformerLayer},
    compile=False
)

# Load the tokenizer
tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')

# Load the dataset used for reference info
data = pd.read_csv('AImodel/dataset.csv')
unique_labels = np.unique(data['disease'])

def preprocess_input(symptoms_texts, non_text_data):
    inputs = tokenizer(symptoms_texts, padding=True, truncation=True, return_tensors="tf", max_length=32)
    input_ids = inputs['input_ids']
    
    # Debugging print
    print(f"TOKENS for symptoms: {symptoms_texts}")
    print(f"input_ids: {input_ids}")
    
    return input_ids, np.array(non_text_data)
def predict_disease(symptoms_texts, non_text_data):
    # If it's one list of symptoms and one non-text vector
    if isinstance(symptoms_texts, list) and len(symptoms_texts) > 0 and isinstance(symptoms_texts[0], str) and len(non_text_data) == 1:
        # Combine symptoms into one string input
        combined_symptoms = " ".join(symptoms_texts)
        input_ids, non_text = preprocess_input([combined_symptoms], non_text_data)
    # If multiple sets of symptoms and matching non_text rows
    elif isinstance(symptoms_texts, list) and len(symptoms_texts) == len(non_text_data):
        input_ids, non_text = preprocess_input(symptoms_texts, non_text_data)
    else:
        raise ValueError("Number of symptoms and non_text_data samples must match, or provide one non_text_data row for combined symptoms.")

    predictions = model.predict([input_ids, non_text])
    results = []
    print("RAW PREDICTIONS:", predictions)
    print("UNIQUE LABELS:", unique_labels)

    for i, pred in enumerate(predictions):
        predicted_label = unique_labels[np.argmax(pred)]
        disease_info = data[data['disease'] == predicted_label].iloc[0]

        result = {
            "input_symptoms": symptoms_texts if isinstance(symptoms_texts[0], str) and len(non_text_data) == 1 else symptoms_texts[i],
            "predicted_disease": predicted_label,
            "other_symptoms": disease_info['symptoms'],
            "suggested_cures": disease_info['cures'],
            "doctor_to_visit": disease_info['doctor'],
            "risk_level": disease_info['risk level']
        }
        results.append(result)
    return results
