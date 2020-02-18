const https = require('https');

exports.lambdaHandler =
    async (event) => {
  const results = {};
  try {
    /***
     * Example usages
     * /stock?symbol=GOOG
     * /stock?hot_stocks
     * /stock?not_hot_stocks
     * /stock?symbol=goog&graph
     * /stocks?symbol=goog&hot_stocks
     */


    /***
     * Main logic
     */
    // Validate that we have a query string
    const queryString = event.queryStringParameters;
    if (!queryString) {
      throw new Error('Missing query string parameter');
    }

    const symbol = queryString.symbol;
    if (Valid.symbol(symbol)) {
      // Get the symbol data
      results.symbol = await IEXCalls.pinnedStocks(symbol);
    }

    const graph = queryString.graph;
    if (Valid.graph(graph, symbol)) {
      // Get the graph data
      results.graph = await IEXCalls.graphInfo(symbol);
    }

    const hotStocks = queryString.hot_stocks;
    if (Valid.hotStocks(hotStocks)) {
      // Get the hotStocks data
      results.hot_stocks = await IEXCalls.hotStocks();
    }

    const notHotStocks = queryString.not_hot_stocks;
    if (Valid.notHotStocks(notHotStocks)) {
      // Get the notHotStocks data
      results.not_hot_stocks = await IEXCalls.notStocks();
    }

    const allSymbols = queryString.all_symbols;
    if (Valid.allSymbols(allSymbols)) {
      // Get an array of all the available symbols
      results.all_symbols = await IEXCalls.allSymbols();
    }
  } catch (err) {
    console.log(err);
    return {statusCode: 422, body: err};
  }

  /***
   * Prepare the response
   */
  const response_data = {
    statusCode: 200,
    body: JSON.stringify(results),
    headers: {
      'Access-Control-Allow-Origin':
          '*',  // Required for CORS support to work
      'Access-Control-Allow-Credentials':
          true  // Required for cookies, authorization headers with HTTPS
    },
  };

  /***
   * Returns the response as a JSON object (the lambda will call JSON.stringify
   * on this result)
   */
  return response_data;
}

/***
 * Functions
 */

// httpResolver resolves a promise with the response of an http request
function httpResolver(res, resolve, reject) {
  var bodyChunks = [];
  res.on('data', function(chunk) {
       bodyChunks.push(chunk);
     }).on('end', function() {
    var body = Buffer.concat(bodyChunks).toString('utf8');

    resolve(JSON.parse(body));
  })
}

// Validator functions used to check user input
Valid = {
  symbol: (symbol) => symbol !== undefined && typeof symbol === 'string',
  graph: (symbol, graph) => graph !== undefined && Valid.symbol(symbol),
  hotStocks: (hotStocks) => hotStocks !== undefined,
  notHotStocks: (notHotStocks) => notHotStocks !== undefined,
  allSymbols: (allSymbols) => allSymbols !== undefined,
}

// Calls to the IEXTrade API (https://iextrading.com/developer/)
IEXCalls = {
  // /stock?symbol=GOOG
  pinnedStocks: async function(symbol) {
    return new Promise((resolve, reject) => {
      https.get(
          'https://api.iextrading.com/1.0/stock/' + symbol + '/quote',
          (res) => httpResolver(res, resolve, reject));
    });
  },
  graphInfo: async function(symbol) {
    // /stocks?symbol=GOOG&graph
    return new Promise((resolve, reject) => {
      https.get(
          'https://api.iextrading.com/1.0/stock/' + symbol + '/chart/1d',
          (res) => httpResolver(res, resolve, reject));
    });
  },
  // stock/?hot_stocks
  hotStocks: async function() {
    // endpoint /stock/market/list/gainers
    return new Promise((resolve, reject) => {
      https.get(
          'https://api.iextrading.com/1.0/stock/market/list/gainers',
          (res) => httpResolver(res, resolve, reject));
    });
  },
  // stock/?not_hot_stocks
  notStocks: async function() {
    // endpoint /stock/market/list/gainers
    return new Promise((resolve, reject) => {
      https.get(
          'https://api.iextrading.com/1.0/stock/market/list/losers',
          (res) => httpResolver(res, resolve, reject));
    });
  },
  // stock/?all_symbols
  allSymbols: async function() {
    return new Promise((resolve, reject) => {
      https.get(
          'https://api.iextrading.com/1.0/ref-data/symbols',
          (res) => httpResolver(res, resolve, reject))
      });
  },
}