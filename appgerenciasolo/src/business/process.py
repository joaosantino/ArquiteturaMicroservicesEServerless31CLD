import json
from src.helpers.dynamo_helper import DynamoHelper
from src.helpers.sns_helper import SNSHelper
from src.helpers.ssm_helper import SSMHelper


class Process:

    def __init__(self, logger):
        self.logger = logger
        self.dynamo_helper = DynamoHelper(logger)
        self.sns_helper = SNSHelper(logger)
        self.ssm_helper = SSMHelper(logger)

    def execute(self, event):
        if event.get('Get'):
            self.logger.info('Iniciando fluxo de GET')
            return self.dynamo_helper.get_item(event.get('Get'))

        if event.get('Records')[0].get('eventSource') == 'aws:sqs':
            self.logger.info('Iniciando fluxo de POST')
            item = json.loads(event.get('Records')[0].get('body'))
            dynamo_response = self.dynamo_helper.put_item(item)
            ssm_response = self.ssm_helper.get_parameter()
            return self.sns_helper.publish_on_topic(ssm_response, dynamo_response, item)
