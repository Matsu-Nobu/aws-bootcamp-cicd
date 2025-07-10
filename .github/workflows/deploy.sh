#!/bin/bash -x


function log () {
  NOW=$(date "+%Y-%m-%d %H:%M:%S%z")
  echo "${NOW} $1"
}

#
# Update Service
#
bash .github/workflows/task_definition.sh > task_definition.json
jq < task_definition.json

TASK_DEFINITION_ARN=$(aws ecs register-task-definition --family "camp20250710-definition-family-miyata" \
  --cli-input-json file://task_definition.json \
  --region ap-northeast-1 \
  --profile learning-account \
  | jq -r .taskDefinition.taskDefinitionArn)

if [ -z "${TASK_DEFINITION_ARN}" ]; then
  log "[FAILED] failed to register task definition"
  exit 1
fi

export ECS_CLUSTER_ARN="arn:aws:ecs:ap-northeast-1:295786672535:cluster/camp20250710-cluster-miyata"
export ECS_SERVICE_NAME="camp20250710-definition-family-miyata-service-fvb77h8e"

LATEST_TASK_DEFINITION=$(aws ecs update-service --cluster "${ECS_CLUSTER_ARN}" \
                                                --service "${ECS_SERVICE_NAME}" \
                                                --task-definition "${TASK_DEFINITION_ARN}" \
                                                --propagate-tags SERVICE \
                                                --region ap-northeast-1 \
                                                --profile learning-account \
                         | jq -r .service.taskDefinition)

if [ "${LATEST_TASK_DEFINITION}" = "${TASK_DEFINITION_ARN}" ]; then
  log "updated service successfully."
else
  log "[FAILED] deploy process failed."
  exit 1
fi

