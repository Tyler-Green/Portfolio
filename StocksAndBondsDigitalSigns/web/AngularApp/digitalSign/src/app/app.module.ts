import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { FormsModule } from '@angular/forms';
import { AuthGuard } from './core/auth.guard';
import { AuthService } from './core/auth.service';
import { UserService } from './core/user.service';
import { UserResolver } from './core/profile-home.resolver';

import { environment } from '../environments/environment';

//Firebase Imports
import { AngularFireModule } from '@angular/fire';
import { AngularFirestoreModule } from '@angular/fire/firestore';
import { AngularFireStorageModule } from '@angular/fire/storage';
import { AngularFireAuthModule } from '@angular/fire/auth';

//Routing imports
import { RouterModule } from '@angular/router';
import { rootRouterConfig } from './app.routes';

//Component imports
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { SettingsComponent } from './settings/settings.component';
import { TwitterTagsComponent } from './twitter-tags/twitter-tags.component';
import { NewsKeysComponent } from './news-keys/news-keys.component';
import { SavedStocksComponent } from './saved-stocks/saved-stocks.component';
import { StockGraphComponent } from './stock-graph/stock-graph.component';
import { HotOrNotComponent } from './hot-or-not/hot-or-not.component';
import { StockSymbolsComponent } from './stock-symbols/stock-symbols.component';
import { TweetsComponent } from './tweets/tweets.component';
import { NewsComponent } from './news/news.component';
import { SharedViewComponent } from './shared-view/shared-view.component';

// Stock Graph imports
import { HttpClientModule } from '@angular/common/http';
import { StockInfoService } from './stock-graph/stock-info.service';


@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    HomeComponent,
    SettingsComponent,
    TwitterTagsComponent,
    NewsKeysComponent,
    SavedStocksComponent,
    StockGraphComponent,
    HotOrNotComponent,
    StockSymbolsComponent,
    TweetsComponent,
    NewsComponent,
    SharedViewComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    AngularFireModule.initializeApp(environment.firebase),
    AngularFirestoreModule, // imports firebase/firestore, only needed for database features
    AngularFireAuthModule, // imports firebase/auth, only needed for auth features,
    AngularFireStorageModule, // imports firebase/storage only needed for storage features
    HttpClientModule,

    RouterModule.forRoot(rootRouterConfig, { useHash: false })
  ],
  providers: [AuthService, AuthGuard, UserService, UserResolver, StockInfoService],
  bootstrap: [AppComponent]
})
export class AppModule { }
