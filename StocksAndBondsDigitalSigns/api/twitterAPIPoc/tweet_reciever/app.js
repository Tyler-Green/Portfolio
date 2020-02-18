const Twitter = require('twitter');

// Good documentation for this:
// https://github.com/desmondmorris/node-twitter/tree/master/examples#tweet

exports.lambdaHandler = async (event, context) => {
  // The query parameter 'q' is used to specify the hashtag to search for.

  let query;
  try {
    query = event.queryStringParameters.q;
    if (!query) {
      return {
        statusCode: 422,
        body: 'Invalid parameters.  Missing required parameter \'q\''
      };
    }
  } catch (err) {
    return {
      statusCode: 422,
      body: 'Invalid parameters.  Missing required parameter \'q\''
    };
  }

  const keys = {
    consumer_key: process.env.TWITTER_CONSUMER_KEY,
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET,
    access_token_key: process.env.TWITTER_TOKEN,
    access_token_secret: process.env.TWITTER_TOKEN_SECRET
  };

  let response = {};

  try {
    const client = new Twitter(keys);

    // result_type = {'mixed', 'popular', 'recent'} (optional)
    const params = {
      q: `#${query}`,
      result_type: 'mixed',
      tweet_mode: 'extended',
      lang: 'en'
    };

    const twitter_response = await client.get('search/tweets', params);

    response = {
      statusCode: 200,
      body: JSON.stringify(twitter_response),
      headers: {
        'Access-Control-Allow-Origin':
            '*',  // Required for CORS support to work
        'Access-Control-Allow-Credentials':
            true  // Required for cookies, authorization headers with HTTPS
      },
    };
  } catch (err) {
    console.error(err);
    return {statusCode: err[0].code, body: err[0].message};
  }

  return response;
};
