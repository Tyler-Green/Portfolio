import { Routes } from '@angular/router';
import { AuthGuard } from './core/auth.guard';
import { UserResolver } from './core/profile-home.resolver';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { SettingsComponent } from './settings/settings.component';
import { SharedViewComponent } from './shared-view/shared-view.component';

export const rootRouterConfig: Routes = [
    { path: '', component: LoginComponent, canActivate: [AuthGuard] },
    { path: 'home', component: HomeComponent, resolve: { data: UserResolver} },
    { path: 'settings', component: SettingsComponent, resolve: { data: UserResolver} },
    { path: 'user/:uID', component: HomeComponent }
  ];