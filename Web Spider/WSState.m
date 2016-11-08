//
//  WSState.m
//  Web Spider
//
//  Created by Alexander on 11/8/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSState.h"
#import "WSSearchPageViewController.h"


@implementation WSState

+ (instancetype)stateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  return [[WSState alloc] initStateWithSearchController:searchPageViewController];
}

- (instancetype)initStateWithSearchController:(WSSearchPageViewController *)searchPageViewController; {
  if (self = [super init]) {
    _searchPageViewController = searchPageViewController;
  }
  return self;
}

- (void)goToState:(WSState *)state {
  _searchPageViewController.currentState = state;
}

@end
