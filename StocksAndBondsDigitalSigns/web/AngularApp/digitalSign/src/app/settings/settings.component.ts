import { Component, OnInit } from '@angular/core';
import {PostService} from './../post.service';

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.css']
})
export class SettingsComponent implements OnInit {

  sharedLink:String;

  constructor(private postService: PostService) { }

  ngOnInit() {
    let uid = this.postService.getCurrentUid();
    this.sharedLink = "http://localhost:4200/user/" + uid;
  }

  copyUrl() {
    var copyText = (<HTMLInputElement>document.getElementById("shared-url"));
    copyText.select();
    document.execCommand("copy");
  }

}
