# Import necessary libraries
from tensorflow.keras.models import load_model
import numpy as np
from transformers import BertTokenizer
from tensorflow.keras.models import load_model
import numpy as np
from transformers import BertTokenizer
import tensorflow as tf
import pickle


class TransformerLayer(tf.keras.layers.Layer):
    def __init__(self, d_model, num_heads, dff, rate=0.1, **kwargs):
        super(TransformerLayer, self).__init__(**kwargs)
        self.d_model = d_model
        self.num_heads = num_heads
        self.dff = dff
        self.rate = rate

        self.mha = tf.keras.layers.MultiHeadAttention(num_heads=num_heads, key_dim=d_model)
        self.ffn = tf.keras.Sequential([
            tf.keras.layers.Dense(dff, activation='relu'),
            tf.keras.layers.Dense(d_model)
        ])
        self.layernorm1 = tf.keras.layers.LayerNormalization(epsilon=1e-6)
        self.layernorm2 = tf.keras.layers.LayerNormalization(epsilon=1e-6)
        self.dropout1 = tf.keras.layers.Dropout(rate)
        self.dropout2 = tf.keras.layers.Dropout(rate)

    def call(self, x, training=None, mask=None):
        attn_output = self.mha(x, x, x, attention_mask=mask)
        attn_output = self.dropout1(attn_output, training=training)
        out1 = self.layernorm1(x + attn_output)

        ffn_output = self.ffn(out1)
        ffn_output = self.dropout2(ffn_output, training=training)
        out2 = self.layernorm2(out1 + ffn_output)
        return out2

    def get_config(self):
        # This method is necessary for saving and reloading the custom layer
        config = super(TransformerLayer, self).get_config()
        config.update({
            'd_model': self.d_model,
            'num_heads': self.num_heads,
            'dff': self.dff,
            'rate': self.rate
        })
        return config

# Load the trained model
model = load_model('my_model.h5', custom_objects={'TransformerLayer': TransformerLayer})

# Recompile the model (optional, for evaluation or prediction)
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

# Load tokenizer
with open('tokenizer.pkl', 'rb') as f:
    tokenizer = pickle.load(f)

# Example test data (new unseen data)
test_texts = ["bleeding rashes", "High fever and chills"]
test_non_text_data = np.array([
    [35, 1, 0, 0, 0, 0, 1],  # Sample 1
    [50, 0, 1, 1, 0, 1, 0],  # Sample 2
])

# Tokenize and pad test text data
test_inputs = tokenizer(test_texts, padding=True, truncation=True, return_tensors="tf", max_length=32)
test_input_ids = test_inputs['input_ids']
test_attention_mask = test_inputs['attention_mask']

# Make predictions
predictions = model.predict([test_input_ids, test_non_text_data])

# Interpret predictions
for text, pred in zip(test_texts, predictions):
    predicted_index = np.argmax(pred)
    predicted_disease = label_encoder.inverse_transform([predicted_index])[0]
    print(f"Text: {text} - Predicted Disease: {predicted_disease}")
