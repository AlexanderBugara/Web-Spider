//
//  WSURL.h
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSURL : NSURL
+ (BOOL)isStringValidForCreationURL:(NSString *)candidate;
@end
