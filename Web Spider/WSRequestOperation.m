//
//  WSRequestOperation.m
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSRequestOperation.h"
#import "WSURL.h"
#import "HTMLReader.h"

@implementation WSRequestOperation

+ (WSRequestOperation *)operation {
  WSRequestOperation *result = [[WSRequestOperation alloc] init];
  return result;
}

+ (WSRequestOperation *)operationWithURL:(WSURL *)url andKeyword:(NSString *)keyWord {
  WSRequestOperation *operation = [self operation];
  operation.url = url;
  operation.keyWord = keyWord;
  return operation;
}

- (void)main {
  @try {
    
    __weak __typeof(self) weakSelf = self;
    
    [[[NSURLSession sharedSession]
    dataTaskWithURL:self.url
    completionHandler:^(NSData *data,
                        NSURLResponse *response,
                        NSError *error) {
      
      
      
      NSString *contentType = nil;
      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        contentType = headers[@"Content-Type"];
      }
      
      HTMLDocument *document = [HTMLDocument documentWithData:data contentTypeHeader:contentType];
      [weakSelf findAllKeywordsInDocument:document];
      
      NSArray *elements = [document nodesMatchingSelector:@"a"];
      for (HTMLElement *element in elements) {
        WSURL *URL = [WSURL URLWithString:element[@"href"]];
      }
      
    }] resume];
  }
  @catch(...) {
    // Do not rethrow exceptions.
  }
}

- (void)findAllKeywordsInDocument:(HTMLNode *)node {
  NSMutableArray * elements = [NSMutableArray array];
  [elements addObject:node];
  
  while([elements count]) {
    HTMLNode * current = [elements objectAtIndex:0];
    for(HTMLNode *child in current.children) {
      if ([child isKindOfClass:[HTMLTextNode class]] && 
          [[[(HTMLTextNode *)child data] lowercaseString] containsString:[self.keyWord lowercaseString]]) {
      }
      [elements addObject:child];
    }
    
    [elements removeObjectAtIndex:0];
  }
}

@end
