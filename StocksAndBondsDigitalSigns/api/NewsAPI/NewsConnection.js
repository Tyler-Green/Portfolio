var moment = require('moment');
const request = require('request-promise');

exports.lambdaHandler = async (event) => {
    try {
        const queryString = event.queryStringParameters;
        if (!queryString) {
            throw new Error('Missing query string parameter');
        }

        const keywords = queryString.keywords;
        if (keywords == undefined || keywords.length < 1) {
            throw new Error('No Keywords Given');
        }

        // create the urls
        var today = moment().format("YYYY-MM-DD");
        var yesterday = moment().subtract(1, 'days').format("YYYY-MM-DD");
        var urls = [];
        let ii = 0;
        keywords.split(' ').map(keyword => {
            var query = 'https://newsapi.org/v2/top-headlines?q=' + keyword + '&pagesize=5&page=1&language=en&from=' + yesterday + '&to=' + today + '&sortby=relevency&apiKey=52571f158a3a4a24b2e8092f819613bd'
            urls.push(query);
        });
        console.log(urls);


        var retObj = [];
        var data = await NewsCalls.keywordArticles(urls)
        var i = 0;

        for (i = 0; i < data.length; i++) {
            var jsonObj = JSON.parse(data[i]);
            var j = 0;
            for (j = 0; j < jsonObj.totalResults; j++) {
                var ar = jsonObj.articles[j];
                if (ar != undefined) {
                    var articleObj = {
                        title: ar.title,
                        author: ar.author,
                        source: ar.source.name,
                        description: ar.description
                    }
                    console.log(articleObj);
                    retObj.push(articleObj);
                }
            }
        }
        // prepare return value
        const resposeData = {
            statusCode: 200,
            body: JSON.stringify(retObj),
            headers: {
                'Access-Control-Allow-Origin':
                    '*',  // Required for CORS support to work
                'Access-Control-Allow-Credentials':
                    true  // Required for cookies, authorization headers with HTTPS
            }
        };
        return resposeData;
    } catch (err) {
        console.log(err);
        return { statusCode: 422, body: err };
    }
}

NewsCalls = {
    keywordArticles: async function (urls) {
        const promises = urls.map(url => request(url));
        return Promise.all(promises);
    },
}
