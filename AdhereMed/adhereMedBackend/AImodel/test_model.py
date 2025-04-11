import torch
import torch.nn as nn
import numpy as np
import pandas as pd
from joblib import load
from sklearn.preprocessing import StandardScaler

# === Model Definition (must match the one used during training) ===
class AdherenceNet(nn.Module):
    def __init__(self, input_dim):
        super(AdherenceNet, self).__init__()
        self.fc1 = nn.Linear(input_dim, 64)
        self.fc2 = nn.Linear(64, 32)
        self.output = nn.Linear(32, 1)
        self.relu = nn.ReLU()
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.relu(self.fc2(x))
        x = self.sigmoid(self.output(x))
        return x

# === Load Model and Scaler ===
model = AdherenceNet(input_dim=1)
model.load_state_dict(torch.load("adherence_predictor_model.pt"))
model.eval()

scaler = load("scaler.joblib")  # Make sure this file exists

# === Input from user ===
try:
    user_input = float(input("Enter Adherence Percentage (e.g., 74.2): "))
except ValueError:
    print("Invalid input. Please enter a numeric value.")
    exit()

# === Preprocess and Predict ===
# Create DataFrame with column name as 'AdherencePercentage' for consistency with scaler
data = pd.DataFrame([[user_input]], columns=["AdherencePercentage"])

# Scale the input data using the same scaler that was used during training
scaled = scaler.transform(data)

# Convert the scaled input into a PyTorch tensor
tensor = torch.tensor(scaled, dtype=torch.float32)

# Predict the adherence status
with torch.no_grad():
    output = model(tensor)
    prediction = int((output > 0.5).item())  # If output > 0.5, predict Adherent (1), else Non-Adherent (0)

status = "Adherent" if prediction == 1 else "Non-Adherent"
print(f"Predicted Adherence Status: {status}")
