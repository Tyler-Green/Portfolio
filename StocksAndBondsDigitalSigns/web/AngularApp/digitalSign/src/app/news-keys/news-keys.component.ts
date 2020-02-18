import { Component, OnInit } from '@angular/core';
import { PostService } from './../post.service';

@Component({
  selector: 'app-news-keys',
  templateUrl: './news-keys.component.html',
  styleUrls: ['./news-keys.component.css']
})
export class NewsKeysComponent implements OnInit {

  constructor(private postService: PostService) { }

  keys: object[];
  newsKey: string = '';

  ngOnInit() {
    this.postService.getNewsKeys().subscribe(data => {
      this.keys = data;
      console.log(data);
     }) ;
  }

  addNewsKey(){
    if (this.keys.length > 4) {
      console.log('Max of 5 keys!');
    } else if (this.validateNewsKey(this.newsKey)) {
      this.postService.createNewsKey(this.newsKey);
      this.newsKey = '';
      console.log('added newsKey!');
    } else {
      //invalid key
    }
  }

  validateNewsKey(key: string) {
    if (key.length < 1)
      return false;
    return true;
  }

  deleteNewsKey(postID: string) {
    this.postService.removeNewsKey(postID);
  }



}
