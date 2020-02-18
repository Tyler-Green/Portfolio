import { Injectable } from "@angular/core";
import { AngularFirestore, AngularFirestoreCollection } 
from 'angularfire2/firestore';
import { AngularFireAuth } from 'angularfire2/auth';
import * as firebase from 'firebase';


@Injectable()
export class UserService {
  userCollection : AngularFirestoreCollection<any>;
  constructor(
   public db: AngularFirestore,
   public afAuth: AngularFireAuth
 ){
  this.userCollection = this.db.collection('user');

 }

  getCurrentUser(){
    return new Promise<any>((resolve, reject) => {
      var user = firebase.auth().onAuthStateChanged(function(user){
        if (user) {
          resolve(user);
        } else {
          reject('No user logged in');
        }
      })
    })
  }

  updateCurrentUser(value){
    return new Promise <any>((resolve, reject) => {
      var user = firebase.auth().currentUser;
      user.updateProfile({
        displayName: value.name,
        photoURL: user.photoURL
      }).then(res => {
        resolve(res)
      }, err => reject(err))
    })
  }

  addUser(user: any) {
    var userID = firebase.auth().currentUser.uid;

    this.userCollection.doc(user.username).set({
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      uid: userID
  })
  }

}

