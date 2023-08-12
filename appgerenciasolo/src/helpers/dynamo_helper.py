from copy import deepcopy
import boto3

DEFAULT_RESPONSE = {
    "isBase64Encoded": False,
    'statusCode': 500
}


class DynamoHelper:

    def __init__(self, logger):
        self.table = boto3.resource("dynamodb").Table('solos')
        self.logger = logger

    def put_item(self, item) -> dict:
        final_response = deepcopy(DEFAULT_RESPONSE)
        try:
            self.table.put_item(Item=item)
            message = f'Item inserido na tabela com sucesso!'
            final_response['statusCode'] = 200
        except Exception as e:
            message = f'Erro ao inserir Item {item} na tabela! Exception: {e}'

        self.logger.info(message)
        final_response['message'] = message
        return final_response

    def get_item(self, key) -> dict:
        final_response = deepcopy(DEFAULT_RESPONSE)
        try:
            response_item = self.table.get_item(Key=key).get("Item")
            if response_item:
                message = f'Item obtido com sucesso!'
                status_code = 200
            else:
                message = f'Não foi encontrado o item {key}!'
                status_code = 204

            final_response['statusCode'] = status_code
            final_response['body'] = response_item
        except Exception as e:
            message = f'Erro ao obter item {key}! Exception {e}'

        self.logger.info(message)
        final_response['message'] = message
        return final_response
