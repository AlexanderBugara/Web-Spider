//
//  WSSearchState.m
//  Web Spider
//
//  Created by Alexander on 11/8/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSSearchState.h"
#import "WSSearchPageViewController.h"

@implementation WSSearchState

+ (instancetype)stateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  return [[WSSearchState alloc] initStateWithSearchController:searchPageViewController];
}

- (instancetype)initStateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  if (self = [super initStateWithSearchController:searchPageViewController]) {
    searchPageViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"search.cancel") style:UIBarButtonItemStylePlain target:searchPageViewController action:@selector(cancel)];
    
    searchPageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Pause", @"search.pause") style:UIBarButtonItemStylePlain target:searchPageViewController action:@selector(pause)];
    
    [searchPageViewController disableSearchBar];
    
    [[searchPageViewController operationQueue] setSuspended:NO];

  }
  return self;
}

@end
