//
//  WSSettings.m
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSSettings.h"
#import "WSSearchPageViewController.h"

@interface WSSettings()
@property (nonatomic, weak) WSSearchPageViewController *searchPageViewController;
@end

@implementation WSSettings
- (instancetype)initWithSearchViewControler:(WSSearchPageViewController *)searchViewController {
  if (self = [super init]) {
    _searchPageViewController = searchViewController;
  }
  return self;
}

- (void)refreshTitle {
  self.searchPageViewController.navigationItem.title = [self searchURL];
}

- (void)updateTitle:(NSString *)titleURL {
  if (titleURL) {
    self.searchPageViewController.navigationItem.title = titleURL;
    [[NSUserDefaults standardUserDefaults] setObject:titleURL forKey:@"search.url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (NSString *)searchURL {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"search.url"];
}

@end
