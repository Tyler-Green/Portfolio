#!/bin/bash

zip -r -j deployment-package lambda/*
zip -r twitter-api-connection-deployment-package twitterAPIPoc/tweet_reciever/*

# Check ~/.aws/credentials if this fails
aws s3 cp deployment-package.zip s3://stocks-and-bonds-digital-sign/lambda/deployment-package.zip
aws s3 cp twitter-api-connection-deployment-package.zip s3://stocks-and-bonds-digital-sign/lambda/twitter_api_connection_deployment-package.zip


# There is a bit of a cat and mouse issue here, where you can't update the function until the terraform is run,
# so if you get an error here just run the terraform and then the error should go away on the next run.

# Hello world function
aws lambda update-function-code --function-name stocks_and_bonds_digital_sign --s3-bucket stocks-and-bonds-digital-sign --s3-key lambda/deployment-package.zip


# Twitter API function
aws lambda update-function-code --function-name twitter_api_connection --s3-bucket stocks-and-bonds-digital-sign --s3-key lambda/twitter_api_connection_deployment-package.zip

rm deployment-package.zip
rm twitter-api-connection-deployment-package.zip
