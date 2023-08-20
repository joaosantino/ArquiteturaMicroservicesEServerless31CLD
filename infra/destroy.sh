cd first_config/

bucket_name=$(terraform output -raw bucket_name)
table_name=$(terraform output -raw table_name)

aws s3 cp s3://${bucket_name}/terraform/statefile/terraform.tfstate .

sed -e '2,8 s/^/# /' main.tf
sed -i "s/${bucket_name}/BUCKET_NAME/g" main.tf
sed -i "s/${table_name}/TABLE_NAME/g" main.tf

terraform init -backend=false

echo "------------------------Removendo todo o conteudo do bucket----------------------------"
../delete_all_s3_objects.sh ${bucket_name}
echo "---------------------------------------------------------------------------------------"

echo "-----------------------------Deletando todos os recursos-------------------------------"
terraform destroy

rm -rf iam
#rm -rf .terraform
rm -f .terraform.lock.hcl
rm -f dynamodb.tf
rm -f iam.tf
rm -f lambda.tf
rm -f sns.tf
rm -f sqs.tf
#rm -f terraform.tfstate
rm -f terraform.tfstate.backup
rm -f terraform.tfvars
rm -f variables.tf

echo "---------------------------------------------------------------------------------------"