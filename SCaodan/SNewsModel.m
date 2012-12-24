//
//  SNewsModel.m
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SNewsModel.h"

@implementation SNewsItem


@end

@interface SNewsModel ()

@property (nonatomic, copy) NSString * pattern;

@property (nonatomic, assign) NSInteger pageNO;

- (NSMutableArray *) parseWithString:(NSString *) string;

@end

@implementation SNewsModel

- (id) init {
    self = [super init];
    if (self) {
        self.newsArray = [NSMutableArray arrayWithCapacity:20];
        self.pageNO = 1;
        self.request = [SRequest requestWithPath:kCDModuleNewsName dict:@{@"page":@(self.pageNO)}];
        self.pattern = @"<div class=\"c\">\\s*<a href=\"(/[a-zA-Z0-9]*/[0-9]+)\"\\s*>\\s*<span>([^<]*)</span>\\s*</a>\\s*</div>";
    }
    return self;
}


- (void) startWithCompletion:(void (^) (BOOL complete)) complete {
    [self.request startWithHandler:^(id result, NSError *error) {
        if (error) {
            complete(NO);
        } else {
            // 先去掉除body部分
            NSArray * array = [self parseWithString:result];
            [self.newsArray removeAllObjects];
            [self.newsArray addObjectsFromArray:array];
            complete(YES);
        }
    }];
}


- (void) loadMoreWithCompletion:(void (^) (BOOL complete)) complete {
    self.pageNO ++;
    [self.request setParam:@(self.pageNO) forKey:@"page"];
    [self.request startWithHandler:^(id result, NSError *error) {
        if (error) {
            complete(NO);
        }
        NSArray * array = [self parseWithString:result];
        [self.newsArray addObjectsFromArray:array];
        complete(YES);
    }];
}

- (NSMutableArray *) parseWithString:(NSString *) string {
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:20];
    NSError * error;
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:self.pattern options:NSRegularExpressionAnchorsMatchLines error:&error];
    if (error) {
        return array;
    }
    
    NSArray * result = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSTextCheckingResult class]]) {
            NSTextCheckingResult * result = (NSTextCheckingResult *) obj;
            
            NSString * temp = [result rangeAtIndex:0];
            NSRange range1 = [result rangeAtIndex:1];
            NSRange range2 = [result rangeAtIndex:2];
            NSString * ids = [temp substringWithRange:range1];
            NSString * cont = [temp substringWithRange:range2];
            
            SNewsItem * item = [[SNewsItem alloc] init];
            item.nid = ids;
            item.content = cont;
            [array addObject:item];
        }
    }];
    
    return array;
}

@end
