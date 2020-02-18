import { Component, OnInit } from '@angular/core';
import { PostService } from './../post.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-stock-symbols',
  templateUrl: './stock-symbols.component.html',
  styleUrls: ['./stock-symbols.component.css']
})

export class StockSymbolsComponent implements OnInit {

  bookmarks: object[];
  timer;

  constructor(private http: HttpClient, private postService: PostService) { }

  async getStock(stockSymbol: string) {
    console.log(stockSymbol);
    return fetch('https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?symbol=' + stockSymbol)
      .then(response => response.json())
      .then(data => data.symbol)
  }

  ngOnInit() {
    this.postService.getBookmarks().subscribe(bookmarks => {
      let promises = bookmarks.map((bookmark) => {
        return this.getStock(bookmark["stock"]);
      })

      Promise.all(promises).then((data) => {
        this.bookmarks = data;
        console.log('this.bookmarks')
        console.log(this.bookmarks)
      })
    });

    this.timer = setInterval(() => this.rotateBookmarks(), 10000); // 10 seconds.
  }

  ngOnDestroy() {
    clearInterval(this.timer);
  }

  // Puts the top bookmark on the bottom (rotates the array)
  rotateBookmarks() {
    const top = this.bookmarks.shift();
    this.bookmarks.push(top);
  }
}
