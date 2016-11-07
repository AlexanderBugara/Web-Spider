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
@end
