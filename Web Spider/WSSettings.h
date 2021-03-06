//
//  WSSettings.h
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSSearchPageViewController, WSURL;

@interface WSSettings : NSObject
- (instancetype)initWithSearchViewControler:(WSSearchPageViewController *)searchViewController;
- (void)refreshTitle;
- (void)updateTitle:(NSString *)titleURL;
- (WSURL *)searchURL;
- (NSString *)searchURLAbsolutePath;
@end
