//
//  SRequest.m
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SRequest.h"

NSString * const SRequestMethodGet  = @"GET";
NSString * const SRequestMethodPost = @"POST";


@interface SRequest ()

@property (nonatomic, strong) NSMutableURLRequest * request;
@property (nonatomic, strong) NSOperationQueue * operationQueue;

@property (nonatomic, copy) NSString * path;
@property (nonatomic, strong) NSMutableDictionary * requestParams;

- (id) initWithRequestPath:(NSString *) url
                     dict:(NSDictionary *) dict
                   method:(NSString *) method;

- (void) setupRequest;

@end


@implementation SRequest

+ (SRequest *) requestWithPath:(NSString *) path {
    SRequest * request = [SRequest requestWithPath:path dict:nil];
    return request;
}

// 默认位get请求。
+ (SRequest *) requestWithPath:(NSString *) path dict:(NSDictionary *) dict {
    SRequest * request = [SRequest requestWithPath:path dict:dict method:SRequestMethodGet];
    return request;
}


+ (SRequest *) requestWithPath:(NSString *) path
                         dict:(NSDictionary *) dict
                       method:(NSString *) method {
    SRequest * request = [[SRequest alloc] initWithRequestPath:path dict:dict method:method];
    return request;
}


- (id) initWithRequestPath:(NSString *) path
                     dict:(NSDictionary *) dict
                   method:(NSString *) method {
    self = [super init];
    if (self) {
        self.request = [[NSMutableURLRequest alloc] init];
        self.path = path;
        self.requestParams = [NSMutableDictionary dictionaryWithDictionary:dict];
        self.request.HTTPMethod = method;
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self setupRequest];
        
    }
    return self;
}


- (void) startWithHandler:(SRequestHandler) handler {
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:self.operationQueue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
        NSLog(@"%@",response);
        
        
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
        handler(string,error);
        
    }];
}


- (void) setParam:(id) param forKey:(NSString *) key {
    [self.requestParams setValue:param forKey:key];
    [self setupRequest];
}

- (void) setupRequest {
    NSString * urlString = kCDHostName;
    if (self.path && ![self.path isEqualToString:@""]) {
        urlString = [urlString stringByAppendingString:self.path];
    }
    if ([self.request.HTTPMethod isEqualToString:SRequestMethodGet]) {
        // GET 请求
        NSMutableString * temp = [NSMutableString stringWithString:@"/?sid=testSid"];
        [self.requestParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [temp appendFormat:@"&%@=%@",key,obj];
        }];
        self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,temp]];
        NSLog(@"GET请求地址%@",self.request.URL);
    } else {
        // POST 请求
    }
    
}

@end
