import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import {PostService} from './../post.service';

@Component({
  selector: 'app-shared-view',
  templateUrl: './shared-view.component.html',
  styleUrls: ['./shared-view.component.css']
})
export class SharedViewComponent implements OnInit {

  currentUID:string = '';

  constructor(private activatedRoute:ActivatedRoute, private postService: PostService) { }

  ngOnInit() {
  }

}
