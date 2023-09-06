from copy import deepcopy
import boto3

DEFAULT_RESPONSE = {
    'statusCode': 500
}


class SSMHelper:

    def __init__(self, logger):
        self.client = boto3.client('ssm')
        self.logger = logger
        self.parameter_name = '/app-dynamostream/SNSTopicARN'

    def get_parameter(self) -> dict:
        final_response = deepcopy(DEFAULT_RESPONSE)
        try:
            response = self.client.get_parameter(Name=self.parameter_name)
            message = f'Parametro {self.parameter_name} obtido!'
            final_response['statusCode'] = 200
            final_response['topicArn'] = response.get('Parameter').get('Value')
        except Exception as e:
            final_response['topicArn'] = ''
            message = f'Erro ao obter parametro .:. Exception: {e}'

        self.logger.info(message)
        final_response['message'] = message
        return final_response
