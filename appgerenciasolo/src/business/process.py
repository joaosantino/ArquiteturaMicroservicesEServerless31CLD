import json
from src.helpers.dynamo_helper import DynamoHelper
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
        self.dynamo_helper = DynamoHelper(logger)
        self.sns_helper = SNSHelper(logger)
        self.ssm_helper = SSMHelper(logger)

    def execute(self, event):
        if event.get('httpMethod', '').__eq__('GET'):
            self.logger.info('Iniciando fluxo de GET')
            query_string_parameters = event.get('queryStringParameters')

            if not query_string_parameters:
                raise Exception('Parametros não enviados!')

            treated_parameters = handle_received_parameters(query_string_parameters)

            return self.dynamo_helper.get_item(treated_parameters)

        if event.get('Records', RECORD)[0].get('eventSource') == 'aws:sqs':
            self.logger.info('Iniciando fluxo de POST')
            item = json.loads(event.get('Records')[0].get('body'))
            dynamo_response = self.dynamo_helper.put_item(item)
            ssm_response = self.ssm_helper.get_parameter()
            sns_response = self.sns_helper.publish_on_topic(ssm_response, dynamo_response, item)
            return handle_responses(dynamo_response, ssm_response, sns_response)
