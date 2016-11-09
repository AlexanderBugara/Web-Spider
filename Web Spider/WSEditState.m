//
//  WSEditState.m
//  Web Spider
//
//  Created by Alexander on 11/8/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSEditState.h"
#import "WSSearchPageViewController.h"

@interface WSEditState ()
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, weak) UISearchBar *searchBar;
@end

@implementation WSEditState

+ (instancetype)stateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  return [[WSEditState alloc] initStateWithSearchController:searchPageViewController];;
}

- (void)goToState:(WSState *)state {
  [self.searchPageViewController.navigationController.navigationBar removeGestureRecognizer:self.tapGestureRecognizer];
  
  [super goToState:state];
}

- (instancetype)initStateWithSearchController:(WSSearchPageViewController *)searchPageViewController {
  if (self = [super initStateWithSearchController:searchPageViewController]) {
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:searchPageViewController action:@selector(presentURLEditPopup:)];
    [searchPageViewController.navigationController.navigationBar addGestureRecognizer:tapGestureRecognizer];
    
    self.tapGestureRecognizer = tapGestureRecognizer;
    
    [searchPageViewController enableSearchBar];
    
    [searchPageViewController.operationQueue cancelAllOperations];
    [searchPageViewController resetSearchProgress];
    
    searchPageViewController.navigationItem.leftBarButtonItem = nil;
    searchPageViewController.navigationItem.rightBarButtonItem = nil;
    
  }
  return self;
}

@end
