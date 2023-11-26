import json

def handler(event, context):
    body = json.loads(event.get("body"))
    username = body["username"]
    password = body["password"]
    is_user_authenticated = username and password
    if is_user_authenticated:
        return { "statusCode": 302 }


