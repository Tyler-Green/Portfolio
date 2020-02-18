import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HotOrNotComponent } from './hot-or-not.component';

describe('HotOrNotComponent', () => {
  let component: HotOrNotComponent;
  let fixture: ComponentFixture<HotOrNotComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HotOrNotComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HotOrNotComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
