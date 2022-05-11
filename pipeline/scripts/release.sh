#!/usr/bin/env bash

#Store an evidence within the bucket storage

COS-API-KEY="$(get_env cos-api-key "")"
COS-BUCKET-NAME="$(get_env cos-bucket-name "")"
COS-ENDPOINT="$(get_env cos-endpoint "")"

echo "testing the cocoa cli"
cat >> sample.log << 'END'
line-1
line-2
END

echo $COS-API-KEY $COS-BUCKET-NAME $COS-ENDPOINT "running pipeline"
cocoa evidence upload --COS_API_KEY=$COS-API-KEY --COS_BUCKET_NAME=$COS-BUCKET-NAME --COS_ENDPOINT=$COS-ENDPOINT --artifact=./sample.log
