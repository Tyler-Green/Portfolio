import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreCollection } from '@angular/fire/firestore';
import * as firebase from 'firebase';
import { Observable } from 'rxjs';
import { ActivatedRoute } from '@angular/router';


interface Post {
  tag: string,
  uid: string
}


@Injectable({
  providedIn: 'root'
})
export class PostService {
  postCollection: AngularFirestoreCollection<any>;
  bookmarkCollection: AngularFirestoreCollection<any>;
  newsKeyCollection: AngularFirestoreCollection<any>;
  postCollectArray: AngularFirestoreCollection<any>;
  userPosts: Observable<Post[]>;

  constructor(public db: AngularFirestore, private activatedRoute: ActivatedRoute) {
    this.postCollection = this.db.collection('hashtag');
    this.bookmarkCollection = this.db.collection('bookmarks');
    this.newsKeyCollection = this.db.collection('newsKey');
  }

  getCurrentUid() {
    var path = window.location.pathname;
    var user = path.split("user/");

    if (user.length > 1) {
      return user[user.length - 1];
    } else {
      return firebase.auth().currentUser.uid;
    }
  }

  /* Get from collection functions below */

  getUserTags() {
    this.postCollectArray = this.db.collection<any>('hashtag', ref => ref.where("uid", "==", this.getCurrentUid()));
    this.userPosts = this.postCollectArray.valueChanges();
    return this.userPosts;
  }

  getBookmarks() {
    this.postCollectArray = this.db.collection<any>('bookmarks', ref => ref.where("uid", "==", this.getCurrentUid()));
    this.userPosts = this.postCollectArray.valueChanges();
    return this.userPosts;
  }

  getNewsKeys() {
    this.postCollectArray = this.db.collection<any>('newsKey', ref => ref.where("uid", "==", this.getCurrentUid()));
    this.userPosts = this.postCollectArray.valueChanges();
    return this.userPosts;
  }

  /* create functions below */

  createTag(tag: string) {
    var userID = firebase.auth().currentUser.uid;
    const id = this.db.createId();
    const postID = this.db.createId();
    this.postCollection.doc(id).set({
      tag: tag,
      isChecked: false,
      postID: postID,
      uid: userID
    });
  }

  createBookmark(stock: string, full_name: string) {
    var userID = firebase.auth().currentUser.uid;
    const id = this.db.createId();
    const postID = this.db.createId();
    this.bookmarkCollection.doc(id).set({
      stock: stock,
      fullStockName: full_name,
      postID: postID,
      uid: userID
    });
  }

  createNewsKey(key: string) {
    var userID = firebase.auth().currentUser.uid;
    const id = this.db.createId();
    const postID = this.db.createId();
    this.newsKeyCollection.doc(id).set({
      key: key,
      postID: postID,
      uid: userID
    });
  }

  /* delete functions below */
  removePost(postID: string) {
    var postQuery = this.db.collection<any>('hashtag', ref => ref.where("postID", "==", postID));
    postQuery.get().toPromise().then(function (querySnapshot) {
      querySnapshot.forEach(function (doc) {
        doc.ref.delete();
      });
    });
  }

  removeNewsKey(postID: string) {
    var postQuery = this.db.collection<any>('newsKey', ref => ref.where("postID", "==", postID));
    postQuery.get().toPromise().then(function (querySnapshot) {
      querySnapshot.forEach(function (doc) {
        doc.ref.delete();
      });
    });
  }

  removeStock(postID: string) {
    var postQuery = this.db.collection<any>('bookmarks', ref => ref.where("postID", "==", postID));
    postQuery.get().toPromise().then(function (querySnapshot) {
      querySnapshot.forEach(function (doc) {
        doc.ref.delete();
      });
    });
  }

  /* Update functions below */

  updatePost(postID: string, isChecked: boolean) {
    var postQuery = this.db.collection<any>('hashtag', ref => ref.where("postID", "==", postID));
    postQuery.get().toPromise().then(function (querySnapshot) {
      querySnapshot.forEach(function (doc) {
        doc.ref.update({ isChecked: !isChecked });
      });
    });
  }

}
