from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_MY_Test():
    """MY Test : vérifie qu'on reçoit un statut 200 et HELLO WORLD en retour"""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "HELLO WORLD"}