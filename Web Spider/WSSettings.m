//
//  WSSettings.m
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSSettings.h"
#import "WSSearchPageViewController.h"
#import "WSURL.h"

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
  self.searchPageViewController.urlLabel.text = [self searchURLAbsolutePath];
}

- (void)updateTitle:(NSString *)titleURL {
  if (titleURL) {
    [[NSUserDefaults standardUserDefaults] setObject:titleURL forKey:@"search.url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self refreshTitle];
  }
}

- (WSURL *)searchURL {
  return [WSURL URLWithString:[self searchURLAbsolutePath]];
}

- (NSString *)searchURLAbsolutePath {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"search.url"];
}

@end
