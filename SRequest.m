//
//  SRequest.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SRequest.h"

@implementation SRequest

@synthesize urlRequest = _urlRequest;



+ (SRequest *) requestWithPath:(NSString *) path {
    return [SRequest requestWithPath:path dict:nil];
}

// 默认位get请求。
+ (SRequest *) requestWithPath:(NSString *) path dict:(NSDictionary *) dict {
    return [SRequest requestWithPath:path dict:dict method:@"GET"];

}

+ (SRequest *) requestWithPath:(NSString *) path 
                          dict:(NSDictionary *) dict 
                        method:(NSString *) method {
    
    SRequest * request = [[[SRequest alloc] init]autorelease];
    request.urlRequest = [[request URLRequestWithPath:path dict:dict method:method] retain];
    return request;
    
}

+ (SRequest *) postWithImage:(UIImage *) image description:(NSString *)description {
    SRequest * request = [[[SRequest alloc] init]autorelease];
    
    NSString * boundry = @"SIGNAL";
    
    NSData * data = UIImagePNGRepresentation(image);
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://lovecard.sinaapp.com/open/photo/upload.action"]]];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:
     [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
      forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData =
    [NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:
     [[NSString stringWithFormat:@"--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:
     [[NSString stringWithFormat:
       @"Content-Disposition: form-data; name=\"postcard\"; filename=\"postcard-fromios.png\"\r\n\r\n"]
      dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    
    request.urlRequest = [urlRequest retain];
    
    return request;
}

- (void) dealloc {
    [_urlRequest release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (id) initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (NSURLRequest *) URLRequestWithPath:(NSString *) path dict:(NSDictionary *) dict method:(NSString *)method {
    NSMutableURLRequest * urlRequest;
    if ([method isEqualToString:@"POST"]) {
        //
        NSString * url = [NSString stringWithFormat:@"%@/%@",kHostIP,path];
        urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        
        [urlRequest setHTTPMethod:@"POST"];
        
        NSString * httpHead = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
        [urlRequest setValue: httpHead forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData * formData = [[NSMutableData alloc]init];
        
        
        NSString * sboundry = [NSString stringWithFormat:@"--%@\r\n",kBoundary];
        NSString * eboundry = [NSString stringWithFormat:@"\r\n--%@--\r\n",kBoundary];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * key, id value, BOOL *stop) {
            
            [formData appendData:[sboundry dataUsingEncoding:NSUTF8StringEncoding]];
            
            if ([key isEqualToString:@"image"]) {
                //
                NSString * content = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"postcard\"; filename=\"postcard.png\"\r\n\r\n"];
                [formData appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
                [formData appendData:value];
            }else {
                //
                [formData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [formData appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [formData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
        } ];
        
        [formData appendData:[eboundry dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:formData];
        
        
        [formData release];

        
    }
    
    return urlRequest;    
}

//( void (^)(NSDictionary * dict,NSError * error)) handler 
- (void) startWithCompleteHandler:( void (^)(id,NSError *)) handler  {
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    
    [NSURLConnection sendAsynchronousRequest:_urlRequest queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        //
        NSError * jsonError;
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        handler(result,error);
    }];
    
}




@end
