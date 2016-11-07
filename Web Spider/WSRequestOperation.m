//
//  WSRequestOperation.m
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WSRequestOperation.h"
#import "WSURL.h"

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

//- (void)start {
//  // Always check for cancellation before launching the task.
//  if ([self isCancelled])
//  {
//    // Must move the operation to the finished state if it is canceled.
//    [self willChangeValueForKey:@"isFinished"];
//    finished = YES;
//    [self didChangeValueForKey:@"isFinished"];
//    return;
//  }
//  
//  // If the operation is not canceled, begin executing the task.
//  [self willChangeValueForKey:@"isExecuting"];
//  [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
//  executing = YES;
//  [self didChangeValueForKey:@"isExecuting"];
//}

- (void)main {
  @try {
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:self.url
                                          completionHandler:^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError *error) {
                                            
                                            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            
                                          }];
    [downloadTask resume];
    
  }
  @catch(...) {
    // Do not rethrow exceptions.
  }
}


// Do some work on myData and report the results.
//    BOOL isDone = NO;
//
//    while (![self isCancelled] && !isDone) {
//      // Do some work and set isDone to YES when finished
//      // NSURLSession *session = [[NSURLSessio alloc] ini]
//    }
@end
