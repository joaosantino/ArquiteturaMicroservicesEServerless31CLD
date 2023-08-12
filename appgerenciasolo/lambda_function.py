import logging
from copy import deepcopy
from src.business.process import Process


logger = logging.getLogger()
logger.setLevel(logging.INFO)
process = Process(logger)


DEFAULT_RESPONSE = {
    "isBase64Encoded": False,
    'statusCode': 500,
    'body': ''
}


def lambda_handler(event, context):
    final_response = deepcopy(DEFAULT_RESPONSE)
    logger.info('Iniciando Lambda!')

    try:
        final_response = process.execute(event)
        logger.info('Lambda executada com sucesso!')
    except Exception as e:
        final_response['message'] = 'Lambda executada com erro!'
        final_response['exception'] = str(e)
        logger.info(f'{final_response}')

    logger.info('Finalizando Lambda!')
    logger.info(final_response)
    return final_response
