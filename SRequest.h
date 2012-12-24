//
//  SRequest.h
//  SPhoto
//
//  Created by SunJiangting on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kHostIP @"http://lovecard.sinaapp.com"

#define kBoundary @"LOVESUNSTAR"

#import <Foundation/Foundation.h>

//
//@protocol SRequestDelegate <NSObject>
//
//@required
//
//- (void) didBeginRequest;
//
//@end


@interface SRequest : NSObject {
    
}

@property (nonatomic, retain) NSURLRequest * urlRequest;

- (void) startWithCompleteHandler:( void (^)(id, NSError *)) handler;

- (NSURLRequest *) URLRequestWithPath:(NSString *) path dict:(NSDictionary *) dict method:(NSString *)method;



+ (SRequest *) requestWithPath:(NSString *) path;

// 默认位get请求。
+ (SRequest *) requestWithPath:(NSString *) path dict:(NSDictionary *) dict;


+ (SRequest *) requestWithPath:(NSString *) path dict:(NSDictionary *) dict method:(NSString *) method;

+ (SRequest *) postWithImage:(UIImage *) image description:(NSString *)description;

    
@end
