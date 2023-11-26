from link.token.lambda_handler import handler

EVENT = {"queryStringParameters": {}}

def test_token_happy_path():
    assert handler(EVENT, {})