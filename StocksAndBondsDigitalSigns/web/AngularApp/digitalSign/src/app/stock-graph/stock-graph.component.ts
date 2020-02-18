import { Component, OnInit, OnDestroy } from '@angular/core';
import { StockInfoService } from './stock-info.service';
import { Chart } from 'chart.js';
import { PostService } from './../post.service';

@Component({
  selector: 'app-stock-graph',
  templateUrl: './stock-graph.component.html',
  styleUrls: ['./stock-graph.component.css']
})
export class StockGraphComponent implements OnInit, OnDestroy {

  chart = [];
  bookmarks: object[];
  rotatingIndex = 0;
  timer;
  bookmarkSub;
  stockSub;

  constructor(private postService: PostService, private _stock_service: StockInfoService) { }

  ngOnDestroy() {

    clearInterval(this.timer);

    // Observable cleanup.
    if (this.bookmarkSub != null) {
      this.bookmarkSub.unsubscribe();
    }

    if (this.stockSub != null) {
      this.stockSub.unsubscribe();
    }

  }

  ngOnInit() {

    this.bookmarkSub = this.postService.getBookmarks().subscribe(data => {
      this.bookmarks = data;
      this.rotatingIndex = 0;
      this.rotateBookmark(); // Start rotation as soon as we get our saved bookmarks.
    });

    this.timer = setInterval(() => this.rotateBookmark(), 10000); // 10 seconds.

  }

  rotateBookmark() {
    if (this.bookmarks == null) {
      return;
    }
    var maxIndex = this.bookmarks.length - 1;
    if (maxIndex < 0) {
      return;
    }
    var bookmark: any
    bookmark = this.bookmarks[this.rotatingIndex];
    var stockName = bookmark.stock;
    if (stockName != null) {

      this.updateGraph(stockName);

      // Rotate through all of our available stocks.
      this.rotatingIndex++;
      if (this.rotatingIndex > maxIndex) {
        this.rotatingIndex = 0;
      }
    }

  }

  async updateGraph(symbol) {
    this.stockSub = this._stock_service.currentStockInformation(symbol).subscribe(res1 => {
      let res: any
      res = res1["graph"];
      let lastVal = null;
      let average = res.map(res => {
        if (res.average > 0) {
          lastVal = res.average;
        }

        return lastVal;
      });
      let alldates = res.map(res => res.minute);
      let stockDates = []
      alldates.forEach((res) => {
        let jsdate = new Date(res * 1000)
        stockDates.push(jsdate.toLocaleTimeString('en', { year: 'numeric', month: 'short', day: 'numeric' }))
      })

      var ctx = document.getElementById("myChart");

      if (ctx == null) {
        return;
      }

      this.chart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: alldates,
          datasets: [
            {
              data: average,
              borderColor: "#3cba9f",
              fill: false
            },
          ]
        },
        options: {
          title: {
            display: true,
            text: symbol
          },
          elements: {
            point: {
              radius: 0
            }
          },
          legend: {
            display: false
          },
          scales: {
            xAxes: [{
              display: false
            }],
            yAxes: [{
              display: true
            }],
          }
        }
      });
    })
  }

}
