from link.authorize.lambda_handler import handler

EVENT = {"queryStringParameters": {}}

def test_authorize_happy_path():
    response = handler(EVENT, {})
    assert response["statusCode"] == 302
    assert response["headers"]["Location"] == "localhost"