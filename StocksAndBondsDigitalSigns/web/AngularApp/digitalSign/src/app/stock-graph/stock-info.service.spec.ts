import { TestBed, inject } from '@angular/core/testing';

import { StockInfoService } from './stock-info.service';

describe('StockInfoService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [StockInfoService]
    });
  });

  it('should be created', inject([StockInfoService], (service: StockInfoService) => {
    expect(service).toBeTruthy();
  }));
});
