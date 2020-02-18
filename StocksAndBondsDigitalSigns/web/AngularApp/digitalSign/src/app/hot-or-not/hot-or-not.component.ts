import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { interval } from 'rxjs';

@Component({
  selector: 'app-hot-or-not',
  templateUrl: './hot-or-not.component.html',
  styleUrls: ['./hot-or-not.component.css']
})
export class HotOrNotComponent implements OnInit {

  stocks: object[];
  constructor(private http: HttpClient) { }

  getHotOrNotStocks() {
    return this.http.get('https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?hot_stocks&not_hot_stocks')
      .subscribe(data => {
        this.stocks = data["hot_stocks"].concat(data["not_hot_stocks"]);
        this.shuffleArray(this.stocks);
        console.log(this.stocks);
      });
  }

  shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
    return array;
  }

  ngOnInit() {
    this.getHotOrNotStocks();
    interval(8000)
      .subscribe(() => {
        //remove 3 stocks from array
        this.stocks = this.stocks.slice(3, this.stocks.length);
        // Check if we need more stock cards
        if (this.stocks.length < 9) {
          this.getHotOrNotStocks();
        }
      });
  }







}
