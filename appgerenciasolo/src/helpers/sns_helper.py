from copy import deepcopy
from src.helpers.util import create_message
import boto3

DEFAULT_RESPONSE = {
    'statusCode': 500
}


class SNSHelper:

    def __init__(self, logger):
        self.client = boto3.client('sns')
        self.logger = logger

    def publish_on_topic(self, ssm_response, dynamo_response, item) -> dict:
        final_response = deepcopy(DEFAULT_RESPONSE)
        try:
            self.client.publish(
                TopicArn=ssm_response.get('topicArn', ''),
                Message=create_message(dynamo_response.get('message'), item),
                Subject='Trabalho Arquitetura Microservices e Serverless - 31CLD'
            )
            message = f'Mensagem publicada no tópico!'
            final_response['statusCode'] = 200
        except Exception as e:
            message = f'Erro ao publicar mensagem no tópico .:. Exception: {e}'

        self.logger.info(message)
        ssm_response.pop('topicArn')
        final_response['dynamo_response'] = dynamo_response
        final_response['ssm_response'] = ssm_response
        final_response['message'] = message
        return final_response
