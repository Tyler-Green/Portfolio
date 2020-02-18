import {Component, OnInit} from '@angular/core';
import {Router} from '@angular/router';
import {AuthService} from '../core/auth.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  constructor(public router: Router, public authService: AuthService) {}

  isAdmin:Boolean = false;

  ngOnInit() {
    var path = window.location.pathname;
    var user = path.split("user/");

    if (user.length > 1) {
      this.isAdmin = false;
    } else {
      this.isAdmin = true;
    }
  }



  logout() {
    this.authService.doLogout().then(
        res => {
          this.router.navigate(['/']);
        },
        error => {
          console.log('Logout error', error);
        });
  }
}
