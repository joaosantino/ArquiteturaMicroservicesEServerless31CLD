#!/bin/bash

cd first_config/

bucket_name=$(terraform output -raw bucket_name)
table_name=$(terraform output -raw table_name)

terraform state rm aws_dynamodb_table.statelock
terraform state rm aws_s3_bucket.bucket

sed -i '2,8 s/^/#/' main.tf
sed -i "s/${bucket_name}/BUCKET_NAME/g" main.tf
sed -i "s/${table_name}/TABLE_NAME/g" main.tf

echo "-----------------------------Deletando todos os recursos-------------------------------"
terraform init -migrate-state -force-copy
terraform destroy -auto-approve

rm -rf iam
rm -rf .terraform
rm -f .terraform.lock.hcl
rm -f dynamodb.tf
rm -f iam.tf
rm -f lambda.tf
rm -f sns.tf
rm -f sqs.tf
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
rm -f terraform.tfvars
rm -f variables.tf

echo "---------------------------------------------------------------------------------------"

echo "------------------------Removendo todo o conteudo do bucket----------------------------"
../delete_all_s3_objects.sh ${bucket_name}
aws dynamodb delete-table --table-name ${table_name} > dynamo_delete.json
aws s3api delete-bucket --bucket ${bucket_name} > bucket_delete.json
rm -f *_delete.json
echo "---------------------------------------------------------------------------------------"