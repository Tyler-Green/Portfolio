import { Component, OnInit } from '@angular/core';
import { PostService } from './../post.service';
import { interval } from 'rxjs';

@Component({
  selector: 'app-tweets',
  templateUrl: './tweets.component.html',
  styleUrls: ['./tweets.component.css']
})

export class TweetsComponent implements OnInit {
  constructor(private postService: PostService) { };

  tweets: object[] = [];

  // Gets a tweet by hashtag
  getTweetsByHashtag(hashtag: string) {
    return fetch(
      'https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/tweets?q="' +
      hashtag + '"')
      .then(response => response.json())
      .then(data => data.statuses);
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

  removeTopTweet() {
    this.tweets.shift();
  }

  appendTweets(more_tweets) {
    this.tweets = this.tweets.concat(more_tweets);
  }

  addTweets() {
    // query db for twitter tags, then call api in setInterval iterating
    // through tags
    this.postService.getUserTags().subscribe(tag_data => {
      const new_tweets_arrays_promises =
        tag_data.map(data => data.tag)
          .map(hashtag => this.getTweetsByHashtag(hashtag));

      // Wait until we get an array of tweets for each hashtag
      Promise.all(new_tweets_arrays_promises)
        .then(new_tweets_arrays => new_tweets_arrays.map(new_tweet_array => {
          // Randomize the order of tweets
          new_tweet_array = this.shuffleArray(new_tweet_array);

          // Combine all the arrays of hashtags into this.tweets
          this.appendTweets(new_tweet_array);
        }))
    });
  }


  ngOnInit() {
    // Initially get some tweets
    this.addTweets();

    // Every 3 seconds remove a tweet and check if we need more tweets
    interval(3000)
      .subscribe(() => {
        // Remove a tweet
        this.removeTopTweet();

        // Check if we need more tweets
        if (this.tweets.length < 5) {
          this.addTweets();
        }
      });
  }
}
