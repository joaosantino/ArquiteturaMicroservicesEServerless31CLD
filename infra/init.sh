#!/bin/bash

meu_email=$1
# shellcheck disable=SC2164
cd first_config/

echo "-----------------------------Criando recursos iniciais-------------------------------"
terraform init
terraform apply -auto-approve

bucket_name=$(terraform output -raw bucket_name)
table_name=$(terraform output -raw table_name)
id_account=$(terraform output -raw id_account)
aws_region=$(terraform output -raw aws_region)
echo "-------------------------------------------------------------------------------------"

echo "-----------------------------Recursos Iniciais Criados-------------------------------"
echo "BucketName -> ${bucket_name}"
echo "TableName -> ${table_name}"
echo "-------------------------------------------------------------------------------------"

echo "------------------------Atualizando arquivos com os dados corretos-------------------"
sed -i 's/#//g' main.tf
sed -i "s/BUCKET_NAME/${bucket_name}/g" main.tf
sed -i "s/TABLE_NAME/${table_name}/g" main.tf

cp -rf ../config_stack/* .
sed -i "s/ID_ACCOUNT/${id_account}/g" iam/policies/*.json
sed -i "s/AWS_REGION/${aws_region}/g" iam/policies/*.json

sed -i "s/MYEMAIL/${meu_email}/g" terraform.tfvars
echo "-------------------------------------------------------------------------------------"

echo "---------------Configurando o state file para o Bucket e Tabela criado---------------"
terraform init -migrate-state -force-copy
echo "-------------------------------------------------------------------------------------"

echo "------------------------Enviando aplicações para o Bucket criado---------------------"
../upload_lambda.sh app-gerenciasolo true > ../output_upload_lambda.txt
cat ../output_upload_lambda.txt

#../upload_lambda.sh app-dynamostream true > ../output_upload_lambda.txt
#cat ../output_upload_lambda.txt
rm -f ../output_upload_lambda.txt
echo "-------------------------------------------------------------------------------------"


echo "----------------------Criando os recursos restantes da stack-------------------------"
terraform apply -auto-approve
echo "-------------------------------------------------------------------------------------"

