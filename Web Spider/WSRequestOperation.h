//
//  WSRequestOperation.h
//  Web Spider
//
//  Created by Alexander on 11/7/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSURL;

@interface WSRequestOperation : NSOperation

@property (nonatomic, strong) WSURL *url;
@property (nonatomic, strong) NSString *keyWord;

+ (WSRequestOperation *)operationWithURL:(WSURL *)url andKeyword:(NSString *)keyWord;

@end
