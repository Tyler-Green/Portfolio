import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NewsKeysComponent } from './news-keys.component';

describe('NewsKeysComponent', () => {
  let component: NewsKeysComponent;
  let fixture: ComponentFixture<NewsKeysComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NewsKeysComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NewsKeysComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
