from link.token.lambda_handler import handler

def test_token_happy_path():
    assert handler()