from link.authorization.lambda_handler import handler

def test_authorization_happy_path():
    assert handler()