import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class StockInfoService {

  constructor(private _http: HttpClient) { }

  currentStockInformation(symbol: String) {
    var link = "https://y46m6n742c.execute-api.us-east-1.amazonaws.com/production/stocks/?symbol=" + symbol + "&graph";
    return this._http.get(link);
  }
}
