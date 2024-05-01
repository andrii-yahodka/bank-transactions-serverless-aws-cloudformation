sam init
sam build
sam deploy

sam deploy --guided
sam deploy --capabilities CAPABILITY_NAMED_IAM

curl -X POST <ARN>/production/transactions