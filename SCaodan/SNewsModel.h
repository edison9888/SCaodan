//
//  SNewsModel.h
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

@interface SNewsItem : NSObject

@property (nonatomic, copy) NSString * nid;
@property (nonatomic, copy) NSString * content;

@end

@interface SNewsModel : NSObject

@property (nonatomic, strong) SRequest * request;
@property (nonatomic, strong) NSMutableArray * newsArray;

- (void) startWithCompletion:(void (^) (BOOL complete)) complete;

- (void) loadMoreWithCompletion:(void (^) (BOOL complete)) complete;

@end
