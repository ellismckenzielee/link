import json
from link.login.lambda_handler import handler

EVENT = {"body": json.dumps({"username": "ellis", "password": "password"})}

def test_login_happy_path():
    response =  handler(EVENT, {})
    assert response["statusCode"] == 302