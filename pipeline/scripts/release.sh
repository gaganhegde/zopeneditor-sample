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

echo "printing sample.log"
cat sample.log

echo $(get_env cos-api-key "") $(get_env cos-bucket-name "") $(get_env cos-endpoint "") "running pipeline"
cocoa evidence upload --COS_API_KEY=$(get_env cos-api-key "") --COS_BUCKET_NAME=$(get_env cos-bucket-name "") --COS_ENDPOINT=$(get_env cos-endpoint "") --artifact=./sample.log
