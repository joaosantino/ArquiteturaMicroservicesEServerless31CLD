import json


def create_message(message, item):
    full_message = {
        'Mensagem': message,
        'Item': item,
        'Integrantes': [
            {
                'nome': 'João Santino',
                'matriula': 'RM348314'
            },
            {
                'nome': 'João Santino',
                'matriula': 'RM348314'
            },
            {
                'nome': 'João Santino',
                'matriula': 'RM348314'
            },
            {
                'nome': 'João Santino',
                'matriula': 'RM348314'
            },
            {
                'nome': 'João Santino',
                'matriula': 'RM348314'
            }
        ]
    }
    return json.dumps(full_message, indent=4, ensure_ascii=False)
