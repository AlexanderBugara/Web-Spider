//
//  WSURL.m
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSURL.h"

@implementation WSURL
+ (BOOL)isStringValidForCreationURL:(NSString *)candidate {

  NSURL *candidateURL = [NSURL URLWithString:candidate];
  
  if (candidateURL && candidateURL.scheme && candidateURL.host) {
    return YES;
  }
  
  return NO;
}

- (NSString *)fixedWithScheme:(NSString *)scheme
              andHost:(NSString *)host {
  
  NSString *firstPart = nil;
  if (self.host) {
    scheme = [scheme stringByAppendingString:@":"];
    firstPart = scheme;
  } else {
    scheme = [scheme stringByAppendingString:@"://"];
    
    NSString *firstPart = [scheme stringByAppendingString:host];
    
    if (![self.absoluteString hasPrefix:@"/"]) {
      firstPart = [firstPart stringByAppendingString:@"/"];
    }
  }
  
  
  
  
  
  NSString *absoluteString = [firstPart stringByAppendingString:self.absoluteString];
  
  return absoluteString;
}
@end
