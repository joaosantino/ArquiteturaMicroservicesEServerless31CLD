#!/bin/bash
date=$(date +%Y%m%d-%H%M%S)
zip_file_name=appgerenciasolo_"${date}".zip
lambda_name=GerenciaSolo
bucket_name=lambda-code-store-hocuspocus
bucket_dir=s3://"${bucket_name}/${lambda_name}/"

zip a "${zip_file_name}" ./appgerenciasolo/src ./appgerenciasolo/__init__.py ./appgerenciasolo/lambda_function.py
echo "Arquivo ${zip_file_name} compactado"

aws s3 cp "${zip_file_name}" "${bucket_dir}" --sse AES256
echo "Arquivo ${zip_file_name} enviado para o bucket ${bucket_dir}"

aws lambda update-function-code \
  --function-name "${lambda_name}" \
  --s3-bucket "${bucket_name}" \
  --s3-key "${lambda_name}/${zip_file_name}" \
  --publish --no-paginate > output.json

echo "Lambda ${lambda_name} atualizada com o S3-Key ${bucket_dir}${zip_file_name}"
rm -f output.json
rm -f "${zip_file_name}"