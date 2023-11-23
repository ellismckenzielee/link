from link.auth_code.lambda_handler import handler

def test_auth_code_happy_path():
    assert handler()