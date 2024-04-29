aws cloudformation package --template-file dynamodb_template.yaml --s3-bucket serverless-payment-service --output-template-file dynamodb_template.packaged.yaml
aws cloudformation deploy --template-file dynamodb_template.packaged.yaml --stack-name ServerlessPaymentServiceStack --capabilities=CAPABILITY_NAMED_IAM

aws cloudformation package --template-file api_gateway_template.yaml --s3-bucket serverless-payment-service --output-template-file api_gateway_template.packaged.yaml
aws cloudformation deploy --template-file api_gateway_template.packaged.yaml --stack-name ClientsStack --capabilities=CAPABILITY_NAMED_IAM