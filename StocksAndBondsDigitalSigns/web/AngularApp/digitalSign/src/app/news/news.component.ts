import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { PostService } from './../post.service';
import {interval} from 'rxjs';

@Component({
  selector: 'app-news',
  templateUrl: './news.component.html',
  styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

  //array will be filled with real text from news API
  items:string[] = [];

  constructor(private http: HttpClient, private postService: PostService) { }

  getNews(keyword) {
    return this.http.get('https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/news?keywords='+keyword)
    .subscribe(data => {
      this.items = [];
      for (let i = 0; i < data["length"]; ++i) {
        this.items.push(data[i].description);
      }
    });
  }

  cycleKeys(keywords) {
    let keyCount = 0;
    if (keywords.length > 0) {
      this.getNews(keywords[0].key);
      ++keyCount;
    }
    interval(60000)
      .subscribe(() => {
        if (keyCount < keywords.length){
          this.getNews(keywords[keyCount].key);
          ++keyCount;
        } else {
          keyCount = 0;
        }   
    });
  }

  ngOnInit() {
    this.postService.getNewsKeys().subscribe(data => {
      this.cycleKeys(data);
    });
  }

}
