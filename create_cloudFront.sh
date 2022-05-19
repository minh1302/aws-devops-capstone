#!/bin/sh
aws cloudformation create-stack \
--stack-name aws-devops-capstone-cloudfront \
--template-body file://.circleci/files/cloudfront.yml \
--region=us-east-1 \
--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"