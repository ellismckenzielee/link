from link.authorization.lambda_handler import handler

EVENT = {"queryStringParameters": {}}

def test_authorization_happy_path():
    response = handler(EVENT, {})
    assert response["statusCode"] == 302
    assert response["headers"]["Location"] == "localhost"