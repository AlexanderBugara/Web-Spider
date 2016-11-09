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


const NSInteger kMaxDeep = 5;

@interface WSRequestOperation ()
@end

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
    if (![self isCancelled]) {
      [[[NSURLSession sharedSession]
        dataTaskWithURL:self.url
        completionHandler:^(NSData *data,
                            NSURLResponse *response,
                            NSError *error) {
          
          
          if (error) {
            weakSelf.error = error;
          } else {
            
            NSString *contentType = nil;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
              contentType = headers[@"Content-Type"];
            }
            
            HTMLDocument *document = [HTMLDocument documentWithData:data contentTypeHeader:contentType];
            [weakSelf findAllKeywordsInDocument:document];
            
            NSArray *elements = [document nodesMatchingSelector:@"a"];
            for (HTMLElement *element in elements) {
              
              if ([weakSelf isCancelled]) break;
              WSURL *URL = [WSURL URLWithString:element[@"href"]];
              
              if (URL && (!URL.host || !URL.scheme)) {
                NSString *absolutePath = [URL fixedWithScheme:self.url.scheme andHost:self.url.host];
                URL = [WSURL URLWithString:absolutePath];
              }
              
              if (URL) [weakSelf.references addObject:URL];
              
            }
          }
          
          [weakSelf completeOperation];
          
        }] resume];
    } else {
      [weakSelf completeOperation];
    }
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
        
        [self willChangeValueForKey:@"foundedKeywordCount"];
        ++_foundedKeywordCount;
        [self didChangeValueForKey:@"foundedKeywordCount"];
        
      }
      [elements addObject:child];
    }
    
    [elements removeObjectAtIndex:0];
  }
}

- (id)init {
  self = [super init];
  if (self) {
    executing = NO;
    finished = NO;
  }
  return self;
}

- (BOOL)isConcurrent {
  return YES;
}

- (BOOL)isExecuting {
  return executing;
}

- (BOOL)isFinished {
  return finished;
}


- (void)start {
  
  if ([self isCancelled]) {
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    return;
  }
  
  [self willChangeValueForKey:@"isExecuting"];
  [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
  executing = YES;
  [self didChangeValueForKey:@"isExecuting"];
}

- (void)completeOperation {
  [self willChangeValueForKey:@"isFinished"];
  [self willChangeValueForKey:@"isExecuting"];
  
  executing = NO;
  finished = YES;
  
  [self didChangeValueForKey:@"isExecuting"];
  [self didChangeValueForKey:@"isFinished"];
}

- (NSArray *)nextLevelOperations {
  
  if ([self isCancelled]) return nil;
  
  NSMutableArray *result = [NSMutableArray array];
  if (self.level < kMaxDeep) {
    for (WSURL *url in self.references) {
      
      WSRequestOperation *requestOperation = [WSRequestOperation operationWithURL:url andKeyword:self.keyWord];
      
      requestOperation.level = self.level + 1;
      
      [result addObject:requestOperation];
      
    }
  }
  return [NSArray arrayWithArray:result];
}

- (NSMutableArray *)references {
  
  if (!_references) {
    _references = [NSMutableArray array];
  }
  return _references;
  
}

@end
