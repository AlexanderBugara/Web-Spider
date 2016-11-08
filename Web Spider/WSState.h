//
//  WSState.h
//  Web Spider
//
//  Created by Alexander on 11/8/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSSearchPageViewController;

@interface WSState : NSObject {
  WSSearchPageViewController *_searchPageViewController;
}

- (instancetype)initStateWithSearchController:(WSSearchPageViewController *)searchPageViewController;
+ (instancetype)stateWithSearchController:(WSSearchPageViewController *)searchPageViewController;
- (void)goToState:(WSState *)state;

@property (nonatomic, strong, readonly) WSSearchPageViewController *searchPageViewController;
@end
