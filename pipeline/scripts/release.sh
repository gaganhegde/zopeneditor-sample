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
)

params_artifact_upload_cos=(
    --backend="cos"
    --namespace="ci"
    --pipeline-run-id="${PIPELINE_RUN_ID}"
)

#Parameters required for upload to git.
# params_artifact_upload_git=(
#     --backend="git"
#     --namespace="ci"
#     --pipeline-run-id="${PIPELINE_RUN_ID}"
# )

LOG_FILE_PATH="$(get_env log_file_path "")"
export LOG_FILE_PATH
echo "Creating a sample log file"
cat >> sample.log << 'END'
    sample log file
END


echo "Running the cocoa evidence upload command"
if cocoa evidence upload "${params_evidence[@]}";then
    echo "Evidence uploaded successfully"
else
    echo "Evidence upload unsuccessful"
    exit -1
fi

echo "Running the cocoa evidence upload command"
if cocoa artifact upload "${params_artifact_upload_cos[@]}" "${LOG_FILE_PATH}";then
    echo "Artifact uploaded successfully"
else
    echo "Artifact upload unsuccessful"
    exit -1
fi
