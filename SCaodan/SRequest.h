//
//  SRequest.h
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

extern NSString * const SRequestMethodGet;
extern NSString * const SRequestMethodPost;

typedef void (^SRequestHandler)(id result, NSError * error);

@interface SRequest : NSObject

+ (SRequest *) requestWithPath:(NSString *) path;

// 默认位get请求。
+ (SRequest *) requestWithPath:(NSString *) path dict:(NSDictionary *) dict;


+ (SRequest *) requestWithPath:(NSString *) path
                         dict:(NSDictionary *) dict
                       method:(NSString *) method;

- (void) startWithHandler:(SRequestHandler) handler;

- (void) setParam:(id) param forKey:(NSString *) key;

@end
