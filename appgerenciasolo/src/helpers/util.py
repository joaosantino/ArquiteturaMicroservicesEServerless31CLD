import json


def create_message(message, item):
    content = {
        'Mensagem': message,
        'Item': item,
    }

    full_message = \
        f"{json.dumps(content, indent=4, ensure_ascii=False)}" \
        "\n\nIntegrantes: " \
        "\nRM348314 - João Santino " \
        "\nRM348136 - José Roberto" \
        "\nRM348782 - Pedro Modena" \
        "\nRM347888 - Vanderson Gonçalves" \
        "\nRM347892 - Guilherme Gonçalves"

    return full_message


def handle_responses(dynamo_response, ssm_response, sns_response):
    first_check = [
        dynamo_response.get('statusCode') == 200,
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
                        f' ser numéricos .:. Exception {e}')


def handle_data_from_dynamo(message, response_item):
    try:
        id_solo = int(response_item.get('id_solo', 0))
        id_cultivo = int(response_item.get('id_cultivo', 0))

        body = {
            'message': message,
            'data': {
                'id_solo': id_solo,
                'id_cultivo': id_cultivo,
                'nome_solo': response_item.get('nome_solo', 'error'),
            }
        }
        return json.dumps(body, ensure_ascii=False)
    except Exception as e:
        raise Exception(f'Não foi possível tratar os dados'
                        f' obtidos da base de dados .:. {e}')
