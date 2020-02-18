# Tweet Reciever PoC

## Usage

## Run locally:

To run this locally you must install docker and sam.

To install docker: https://docs.docker.com
To install sam: pip install aws-sam-cli

It might be useful to do a bit of reading on Lambda, API Gateway, and SAM.

And of course run `npm i` in the tweet_reciever directory to install the app dependencies.

Then run the command:

```
sam local start-api --env-vars .env.json
```

Create .env.json using the template provided in .env_example.json

You can then test the lambda functions through an API on your local machine.

## Run on AWS:

If Jordan has this set up just run terraform on a machine with ~/.aws/credentials containing your own aws credentials.
(Or just push to Git and ask Jordan to deploy changes you made)

---

## Development

Edit `tweet_reciever/app.js`
