#!/bin/bash
lambda_name=$1
running_by_script=$2
is_update=$3
zip_file_name="${lambda_name}.zip"

if [ "${running_by_script}" == "true" ]; then
  echo "-> Script executado por init.sh"
  bucket_name=$(terraform output -raw bucket_name)
  cd ..
else
  echo "-> Script executado pelo usuário"
  cd first_config/
#  bucket_name=$(terraform output -raw bucket_name)
  bucket_name=artifacts-stack-224241134590
  cd ..
fi

bucket_dir=s3://"${bucket_name}/apps/${lambda_name}/"

zip a "${zip_file_name}" \
  ../apps/${lambda_name}/src \
  ../apps/${lambda_name}/__init__.py \
  ../apps/${lambda_name}/lambda_function.py
echo "-> Arquivo ${zip_file_name} compactado"

aws s3 cp "${zip_file_name}" "${bucket_dir}" --sse AES256
echo "-> Arquivo enviado para o bucket -> ${bucket_dir}${zip_file_name}"


if [ "${is_update}" == "update" ]; then
  echo "-> Argumento 'update' foi fornecido. Será atualizada a versão do código da Lambda"
  aws lambda update-function-code \
  --function-name "${lambda_name}" \
  --s3-bucket "${bucket_name}" \
  --s3-key "apps/${lambda_name}/${zip_file_name}" \
  --publish --no-paginate > output.json

  echo "-> Lambda ${lambda_name} atualizada com o S3-Key ${bucket_dir}${zip_file_name}"
  cat output.json
  rm -f output.json
else
    echo "-> Argumento 'update' não foi fornecido. Não será atualizada a versão do código da Lambda"
fi

rm -f "${zip_file_name}"