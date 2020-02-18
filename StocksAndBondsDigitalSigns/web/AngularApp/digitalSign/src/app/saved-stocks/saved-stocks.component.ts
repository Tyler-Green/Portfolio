import { Component, OnInit } from '@angular/core';
import { PostService } from './../post.service';
declare var jquery: any;
declare var $: any;

@Component({
  selector: 'app-saved-stocks',
  templateUrl: './saved-stocks.component.html',
  styleUrls: ['./saved-stocks.component.css']
})
export class SavedStocksComponent implements OnInit {

  bookmarks: object[];

  constructor(private postService: PostService) { }

  ngOnInit() {
    this.postService.getBookmarks().subscribe(data => {
      this.bookmarks = data;
      console.log(data);
    });

    this.autocomplete();
  }

  autocomplete() {
    var listOfStocks = this.getStockSymbols();

    $("#bookmark-input").autocomplete({
      source: function (request, response) {
          var matches = $.map(listOfStocks, function (acItem) {
              if (acItem.toUpperCase().indexOf(request.term.toUpperCase()) === 0) {
                  return acItem;
              }
          });
          response(matches);
      },
      select: (e, ui) => {
        this.addBookmark(ui.item.value);
        ui.item.value = '';
      }
    });
    $("#bookmark-input").autocomplete("widget").attr('style', 'max-height: 200px; overflow-y: auto; overflow-x: hidden;')
  }

  getStockSymbols() {

    var listOfStocks = new Array();

    $.get("https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks?all_symbols", function (data, status) {
      let i, stockArray = data.all_symbols;
      //Loop through each stock
      for (i = 0; i < stockArray.length; i++) {
        listOfStocks.push(stockArray[i].name + " ('" + stockArray[i].symbol + "')");
      }
    });
    return listOfStocks;
  }

  addBookmark(bMark: string) {
    if (this.bookmarks.length > 9) {
      console.log('Max of 10 bookmarks!');
    } else if (this.validateBookmark(bMark)) {
      const symbol = bMark.substring(
        bMark.indexOf("'") + 1,
        bMark.lastIndexOf("'")
      );
      this.postService.createBookmark(symbol, bMark);
      (<HTMLInputElement>document.getElementById("bookmark-input")).value = '';
      console.log('added bookmark!');
    } else {
      console.log('invalid bookmark')
    }
  }

  validateBookmark(bMark: string) {
    let listOfStocks = this.getStockSymbols();
    console.log(bMark)
    if (!listOfStocks.indexOf(bMark))
      return false;
    if (bMark.length < 1)
      return false;

    return true;
  }

  deleteBookmark(postID: string) {
    this.postService.removeStock(postID);
  }

}
