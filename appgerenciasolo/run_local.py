from lambda_function import lambda_handler


def test_get():
    event = {
        "Get": {
            "id_solo": 1,
            "id_cultivo": 1
        }
    }
    response = lambda_handler(event, None)
    print(response)


def test_post():
    event = {
        "Records": [
            {
                "body": "{\"id_solo\": 2,\"id_cultivo\": 2,\"nome_solo\": \"solo\"}",
                "eventSource": "aws:sqs"
            }
        ]
    }
    response = lambda_handler(event, None)
    print(response)
