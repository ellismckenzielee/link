def handler(event, context):
    query_params = event.get("queryStringParameters")
    response_type = query_params.get("code")
    client_id = query_params.get("client_id")
    redirect_uri = query_params.get("redirect_uri")
    state = query_params.get("redirect_uri")
    return  {"statusCode": 302, "headers": {
        "Location": "localhost"
    }}
