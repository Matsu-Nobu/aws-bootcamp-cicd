#!/bin/bash

cat <<EOF
{
  "family": "camp20250710-definition-family-miyata",
  "executionRoleArn": "arn:aws:iam::295786672535:role/ecsTaskExecutionRole",
  "networkMode": "awsvpc",
  "runtimePlatform": {
    "cpuArchitecture": "ARM64",
    "operatingSystemFamily": "LINUX"
  },
  "containerDefinitions": [
    {
      "name": "camp20250710-ecs-task-miyata",
      "image": "295786672535.dkr.ecr.ap-northeast-1.amazonaws.com/camp20250710-repo-miyata:v1",
      "cpu": 0,
      "portMappings": [
        {
          "name": "rails-port",
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp",
          "appProtocol": "http"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "RAILS_MASTER_KEY",
          "value": "ea2c55872670eafe54c2673010be0ed7"
        },
        {
          "name": "RAILS_ENV",
          "value": "production"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/camp20250710-miyata",
          "awslogs-create-group": "true",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ],
  "volumes": [],
  "placementConstraints": [],
  "requiresCompatibilities": [
    "FARGATE"
  ],
  "cpu": "1024",
  "memory": "3072"
}
EOF

