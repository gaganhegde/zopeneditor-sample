#!/usr/bin/env bash

#Store an evidence within the bucket storage

echo "testing the cocoa cli"
cat >> sample.log << 'END'
line-1
line-2
END

echo "printing sample.log"
cat sample.log
echo "just fetching some env variables"
echo "pipeline ID"
echo "${PIPELINE_ID}"
echo "pipeline run url"
echo "${PIPELINE_RUN_URL}"
echo "pipeline run ID"
echo "${PIPELINE_RUN_ID}"
echo "toolchain crn"
echo "${TOOLCHAIN_CRN}"
echo "evidence type version"
echo "${EVIDENCE_TYPE_VERSION}"
echo "evidence type"
echo "${EVIDENCE_TYPE}"
echo $(get_env cos-api-key "") $(get_env cos-bucket-name "") $(get_env cos-endpoint "") "running pipeline"
# echo "testing evidence info"
# echo $(get_env evidence-info "")
# cocoa --version
# echo "evidence upload-1"
# cocoa evidence upload --backend=cos --evidence-name=zopeneditor-logs --COS_API_KEY=$(get_env cos-api-key "") --COS_BUCKET_NAME=$(get_env cos-bucket-name "") --COS_ENDPOINT=$(get_env cos-endpoint "")
# echo "evidence upload-2"
# cocoa evidence upload --backend=cos --evidence-name=zopeneditor-logs --COS_API_KEY=$(get_env cos-api-key "") --COS_BUCKET_NAME=$(get_env cos-bucket-name "") --COS_ENDPOINT=$(get_env cos-endpoint "") --artifact=./sample.log d41d8cd98f00b204e9800998ecf8427e
