import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

# Load and preprocess data
def load_and_preprocess_data(filepath):
    data = pd.read_excel(filepath)
    data['AdherenceStatus'] = data['AdherencePercentage'].apply(lambda x: 1 if x >= 80 else 0)
    data = data.drop(columns=['PatientID', 'MedicationDate', 'AppointmentDate', 'DoctorNotes', 'SideEffects'])
    
    X = data[['AdherencePercentage']]
    y = data['AdherenceStatus']
    return X, y

# Split and scale data
def split_and_scale_data(X, y, test_size=0.2):
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_size, random_state=42)
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    return (
        torch.tensor(X_train_scaled, dtype=torch.float32),
        torch.tensor(X_test_scaled, dtype=torch.float32),
        torch.tensor(y_train.values, dtype=torch.float32),
        torch.tensor(y_test.values, dtype=torch.float32),
        scaler
    )

# Define the neural network
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

# Training function
def train_model(model, train_loader, criterion, optimizer, device):
    model.train()
    for epoch in range(10):  # epochs
        for inputs, targets in train_loader:
            inputs, targets = inputs.to(device), targets.to(device).unsqueeze(1)
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs, targets)
            loss.backward()
            optimizer.step()

# Evaluation function
def evaluate_model(model, X_test, y_test, device):
    model.eval()
    with torch.no_grad():
        inputs = X_test.to(device)
        targets = y_test.to(device).unsqueeze(1)
        outputs = model(inputs)
        predictions = (outputs > 0.5).float()
        accuracy = (predictions == targets).float().mean()
        print(f"Model Accuracy: {accuracy.item() * 100:.2f}%")

# Main logic
def main():
    X, y = load_and_preprocess_data("synthetic_Adherence_Data.xlsx")
    X_train, X_test, y_train, y_test, scaler = split_and_scale_data(X, y)

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = AdherenceNet(input_dim=X_train.shape[1]).to(device)

    train_dataset = TensorDataset(X_train, y_train)
    train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)

    criterion = nn.BCELoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

    train_model(model, train_loader, criterion, optimizer, device)
    evaluate_model(model, X_test, y_test, device)

    from joblib import dump
    dump(scaler, "scaler.joblib")

    torch.save(model.state_dict(), "adherence_predictor_model.pt")
    print("Model saved as 'adherence_predictor_model.pt'")

if __name__ == "__main__":
    main()
