#!/usr/bin/env bash

#Store an evidence within the bucket storage

echo "testing the cocoa cli"
cat >> sample.log << 'END'
line-1
line-2
END

echo "printing sample.log"
cat sample.log

echo $(get_env cos-api-key "") $(get_env cos-bucket-name "") $(get_env cos-endpoint "") "running pipeline"
cocoa --version
echo "evidence upload-1"
cocoa evidence upload --evidence-name=zopeneditor-logs --COS_API_KEY=$(get_env cos-api-key "") --COS_BUCKET_NAME=$(get_env cos-bucket-name "") --COS_ENDPOINT=$(get_env cos-endpoint "")
echo "evidence upload-2"
cocoa evidence upload --evidence-name=zopeneditor-logs --COS_API_KEY=$(get_env cos-api-key "") --COS_BUCKET_NAME=$(get_env cos-bucket-name "") --COS_ENDPOINT=$(get_env cos-endpoint "") --artifact=./sample.log d41d8cd98f00b204e9800998ecf8427e
