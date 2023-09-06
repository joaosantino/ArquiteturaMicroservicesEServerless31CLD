import json


def create_message(message, item):
    content = {
        'Mensagem': message,
        'Item': item,
    }

    full_message = \
        f"{json.dumps(content,indent=4,ensure_ascii=False)}"

    return full_message


def handle_responses(ssm_response, sns_response):
    first_check = [
        ssm_response.get('statusCode') == 200,
        sns_response.get('statusCode') == 200,
    ]

    if all(first_check):
        return {
            "isBase64Encoded": False,
            'statusCode': 200,
            'message': 'Item inserido na base e e-mail enviado com sucesso!',
        }
    else:
        return {
            "isBase64Encoded": False,
            'statusCode': 501,
            'message': 'Ocorreu algum problema no processamento!',
        }


def handle_received_parameters(query_string_parameters) -> dict:
    try:
        treated_parameters = {
            'id_solo': int(query_string_parameters.get('id_solo')),
            'id_cultivo': int(query_string_parameters.get('id_cultivo'))
        }
        return treated_parameters
    except Exception as e:
        raise Exception('Não foi recebido valores válidos '
                        'para os campos id_solo e/ou '
                        'id_cultivo, os mesmos devem'
                        f' ser interos .:. Exception {e}')
