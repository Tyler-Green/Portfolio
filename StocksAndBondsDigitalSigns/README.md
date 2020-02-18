# StocksAndBondsDigitalSigns

Group project for CIS\*3750 at the University of Guelph. Creating a digital signage system.

---

## Endpoints

### Angular App

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production

### Twitter API Connection

**To get tweets containing the hashtag 'stocks'**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/tweets?q=stocks

### IEX Trade API Connection

**To get stock data for the stock symbol 'GOOG'**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?symbol=goog

**To get stock data as well as chart data for the stock symbol 'GOOG'**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?symbol=goog&graph

**To get hot stocks**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?hot_stocks

**To get not hot stocks**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?not_hot_stocks

**Also, you can request multiple things at the same time, such as**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?symbol=goog&graph&hot_stocks&not_hot_stocks

**Get all of the available stock symbols on the IEX Trade API**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?all_symbols

### News API Connection

**Get news related to the keyword 'apple' here**

> https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/news?keywords=apple
