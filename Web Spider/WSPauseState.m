//
//  WSPauseState.m
//  Web Spider
//
//  Created by Alexander on 11/8/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSPauseState.h"
#import "WSSearchPageViewController.h"

@implementation WSPauseState

+ (instancetype)stateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  return [[WSPauseState alloc] initStateWithSearchController:searchPageViewController];
}

- (instancetype)initStateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  if (self = [super initStateWithSearchController:searchPageViewController]) {
    
    [[searchPageViewController operationQueue] setSuspended:YES];
    
    searchPageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Resume", @"search.resume") style:UIBarButtonItemStylePlain target:searchPageViewController action:@selector(resume)];
  }
  return self;
}

- (void)goToState:(WSState *)state {
  [super goToState:state];
}

@end
