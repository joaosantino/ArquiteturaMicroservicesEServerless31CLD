## Trabalho de Arquitetura de MicroServices and Serverless Turma 31CLD
<h4>Repositório contendo todo o conteudo do 
trabalho de conclusão da matéria Arquitetura Microservices
e Serverless</h4>

## Arquitetura da solução
Arquitetura do serviço de gerencia de solos, basicamente temos um API GTW que aceita apenas requisições GET/POST,
quando o fluxo é via POST, o conteudo da requisição é adicionado em uma fila SQS que trigeriza uma Lambda(No caso
o código da mesma encontra-se dentro da pasta appgerenciasolo) e a mesma tem integração com o SSM Parameter Store,
com o DynamoDB e o SNS informando o status da gravação na base de dados. Quando a requisição é um GET é direcionado
diretamente pra Lambda Function(mesma aplicação) e realiza a obtenção dos dados na tabela do DynamoDB. O código da
Lambda é armazenado em um bucket especifico e o mesmo pode ser atualizado pelo script upload_lambda.sh no diretório
 raiz do repositório.

<p align="center">
<img src="./doc/ArquiteturaSolucao.png" width="800px" height="auto">
</p>

<h5 align="center">Arquitetura da solução</h5>

## Dependências
- [AWS CLI 2.0](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Python +3.8](https://www.python.org/downloads/)
- [Gitbash](https://git-scm.com/downloads)
- [Pycharm community edition](https://www.jetbrains.com/pycharm/download/)(ou seu IDE preferido)

## Como rodar a aplicação gerenciasolo
    1 - Baixar o repositório e entrar na pasta appgerenciasolo/
    2 - Instalar a Lib virtualenv em seu python, configurar e instalar as dependências:
        -> python -m pip install virtualenv
        -> pip virtualenv venv
        -> source venv/Scripts/activate
        -> pip install -r requirements.txt
    3 - Ter as Access/Secrets Keys do usuário IAM na conta AWS em questão onde a arquitetura foi criada.
    4 - Executar localmente pelo pytest conforme GIF abaixo

<p align="center">
<img src="./doc/prints/PytestExecution.gif" width="800px" height="auto">
</p>

## Como rodar o script upload_lambda.sh
Basta em seu shell script inserir o seguinte comando:
- ./upload_lambda.sh

Com isso o mesmo crirá um zip contendo a pasta src/* e os arquivos lambda_function.py e o arquivo __init__.py, o mesmo
terá a nomenclatura appgerenciasolo_AAAAMMDD_HHMMSS.zip e será prontamente excluido após envio para o bucket S3 e a 
devida atualização da versão da Lambda, na execução do script você obtém informações sobre o estado do mesmo conforme
imagem abaixo

<p align="center">
<img src="./doc/prints/8.3 - Execução do script que atualiza a Lambda.png" width="800px" height="auto">
</p>


## Fluxograma da Aplicação GerenciaSolo
<p align="center">
<img src="./doc/AppGerenciaSolo_FlowChart.png" width="800px" height="auto">
</p>

<h5 align="center">Fluxograma da Aplicação GerenciaSolo</h5>


## Diagrama de classes da Aplicação GerenciaSolo
<p align="center">
<img src="./doc/AppGerenciaSolo_ClassesDiagram.png" width="800px" height="auto">
</p>

<h5 align="center">Diagrama de classes da Aplicação GerenciaSolo</h5>