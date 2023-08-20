bucket_name=$1

while true; do
    aws s3 rm s3://${bucket_name}/apps --recursive
    aws s3 rm s3://${bucket_name}/terraform --recursive
    aws s3api list-object-versions --bucket "${bucket_name}" > tmp.json

    versions=$(cat tmp.json | jq -r '.Versions[] | "\(.VersionId) \(.Key) \(.IsLatest)"')
    versions_length=$(cat tmp.json | jq '.Versions | length')
    while read -r version_id key islatest; do
      if [ "${islatest}" != "false" ] || [ "${versions_length}" == "1" ]; then
        aws s3api delete-object --bucket "${bucket_name}" --key "$key" --version-id "$version_id"
      fi
    done <<< "${versions}"

    delete_markers=$(cat tmp.json | jq -r '.DeleteMarkers[] | "\(.VersionId) \(.Key)"')
    delete_markers_length=$(cat tmp.json | jq '.DeleteMarkers | length')
    while read -r version_id key; do
      if [ "${islatest}" != "false" ] || [ "${delete_markers_length}" == "1" ]; then
        aws s3api delete-object --bucket "${bucket_name}" --key "$key" --version-id "$version_id"
      fi
    done <<< "${delete_markers}"

    if [ "$(cat tmp.json | wc -l)" == "3" ]; then
        echo "Não há mais itens para serem deletados!"
        break
    fi
done

rm -f tmp.json
