#!/usr/bin/env bash

echo "creating required params to upload evidence"
params_evidence=(
    --backend="cos"
    --evidence-name="zopeneditor-sample"
    --namespace="ci"
    --evidence-type="ibm.com.logs"
    --evidence-type-version="2.0"
    --result="success"
    --pipeline-run-id="${PIPELINE_RUN_ID}"
    --toolchain-crn="${TOOLCHAIN_CRN}"
    --pipeline-run-url="${PIPELINE_RUN_URL}"
    --pipeline-id="${PIPELINE_ID}"
    --issue=./sample.log
)

params_artifact_upload_cos=(
    --backend="cos"
    --namespace="ci"
    --pipeline-run-id="${PIPELINE_RUN_ID}"
)

params_artifact_upload_git=(
    --backend="git"
    --namespace="ci"
    --pipeline-run-id="${PIPELINE_RUN_ID}"
)

echo "Creating a sample log file"
cat >> sample.log << 'END'
    line-1
    line-2
END

echo "Running the cocoa evidence upload command"
cocoa evidence upload "${params_evidence[@]}"

echo "Running the artifact upload for COS"
cocoa artifact upload "${params_artifact_upload_cos[@]}" ./sample.log
