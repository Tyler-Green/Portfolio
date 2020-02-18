import { PostService } from './../post.service';
import { Component, OnInit } from '@angular/core';
import { post } from 'selenium-webdriver/http';


@Component({
  selector: 'app-twitter-tags',
  templateUrl: './twitter-tags.component.html',
  styleUrls: ['./twitter-tags.component.css']
})
export class TwitterTagsComponent implements OnInit {

  hashtag: string = '';
  posts: object[];

  constructor(private postService: PostService) { }

  ngOnInit() {
    this.postService.getUserTags().subscribe(data => {
      this.posts = data;
      console.log(data);
     }) ;
  }

  addHashtag(){
    if (this.posts.length > 4) {
      console.log('Max of 5 tags!');
    } else if (this.validateHashtag(this.hashtag)) {
      this.postService.createTag(this.hashtag);
      this.hashtag = '';
      console.log('added tag!');
    } else {
      //invalid hashtag err message
    }
  }

  validateHashtag(hashtag: string) {
      if (hashtag.length < 1)
        return false;
      return true;
  }

  deleteHashtag(postID: string) {
    this.postService.removePost(postID);
  }

  updateSelection(postID: string, isChecked: boolean) {
    this.postService.updatePost(postID, isChecked);
  }

}
