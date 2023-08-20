from lambda_function import lambda_handler


def test_get():
    event = {
        "httpMethod": "GET",
        "queryStringParameters": {
            "id_cultivo": "6",
            "id_solo": "6"
        }
    }
    response = lambda_handler(event, None)
    print(response)


def test_post():
    body = "{\"id_solo\": 8,\"id_cultivo\": 8,\"nome_solo\": \"solo xpto\"}"
    event = {
        "Records": [
            {
                "body": body,
                "eventSource": "aws:sqs"
            }
        ]
    }
    response = lambda_handler(event, None)
    print(response)
