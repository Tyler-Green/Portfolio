import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SavedStocksComponent } from './saved-stocks.component';

describe('SavedStocksComponent', () => {
  let component: SavedStocksComponent;
  let fixture: ComponentFixture<SavedStocksComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SavedStocksComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SavedStocksComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
