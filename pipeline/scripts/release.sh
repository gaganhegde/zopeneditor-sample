#!/usr/bin/env bash

echo "saving params"
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

params_artifact_upload=(
    --backend="cos"
    --namespace="ci"
    --pipeline-run-id="${PIPELINE_RUN_ID}"
)

echo "Printing a list of environment variables"
echo "pipeline run id"
echo ${PIPELINE_RUN_ID}
echo "GHE_TOKEN"
echo ${GHE_TOKEN}
echo "EVIDENCE_REPO_ORG"
echo ${EVIDENCE_REPO_ORG}
echo "Evidence_repo_name"
echo ${EVIDENCE_REPO_NAME}
echo "Namespace"
echo ${NAMESPACE}

echo "Creating a sample log file"
cat >> sample.log << 'END'
    line-1
    line-2
END

echo "Running the cocoa evidence upload command"
cocoa evidence upload "${params_evidence[@]}"

echo "Running the artifact upload"
cocoa artifact upload "${params_artifact_upload[@]}" ./sample.log
