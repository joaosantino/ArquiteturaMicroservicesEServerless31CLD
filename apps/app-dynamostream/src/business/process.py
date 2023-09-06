import json
from src.helpers.sns_helper import SNSHelper
from src.helpers.ssm_helper import SSMHelper
from src.helpers.util import handle_responses, handle_received_parameters

RECORD = [
    {
        'eventSource': ''
    }
]


class Process:

    def __init__(self, logger):
        self.logger = logger
        self.sns_helper = SNSHelper(logger)
        self.ssm_helper = SSMHelper(logger)

    def execute(self, event):
        if event.get('Records', RECORD)[0].get('eventSource') == 'aws:dynamodb':
            item = event.get('Records')[0].get('dynamodb')
            ssm_response = self.ssm_helper.get_parameter()
            sns_response = self.sns_helper.publish_on_topic(ssm_response, item)
            return handle_responses(ssm_response, sns_response)
        
        return {
            "isBase64Encoded": False,
            'statusCode': 501,
            'body': f'{{"messge": "Método não implementado"}}'
        }