//
//  WSRequestOperation.h
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSURL;

@interface WSRequestOperation : NSOperation {
  BOOL        executing;
  BOOL        finished;
}

@property (nonatomic, strong) WSURL *url;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableArray *references;
@property (assign) NSInteger level;
@property (assign) NSInteger foundedKeywordCount;

+ (WSRequestOperation *)operationWithURL:(WSURL *)url andKeyword:(NSString *)keyWord;
- (NSArray *)nextLevelOperationsExcept:(NSSet *)setURL;
@end
