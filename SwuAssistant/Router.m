//
//  Router.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "Router.h"

@interface Router() <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSData *dataForR;

@end

@implementation Router

+ (Router *)sharedInstance {
    static Router *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Router alloc] init];
    });
    return share;
}

- (void)loginWithName:(NSString *)name AndPassword:(NSString *)password AndCompletionHandler:(void (^)(NSString *))blockName {
    self.dataForR = nil;
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://urp6.swu.edu.cn/userPasswordValidate.portal"]];
    [req setHTTPMethod:@"POST"];
    NSString *url1 = @"http://urp6.swu.edu.cn/loginSuccess.portal";
    NSString *url2 = @"http://urp6.swu.edu.cn/loginFailure.portal";
    NSString *token1 = name;
    NSString *token2 = password;
    
    NSString *contents = [NSString stringWithFormat:@"goto=%@&gotoOnFail=%@&Login.Token1=%@&Login.Token2=%@", url1, url2, token1,token2];
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session downloadTaskWithRequest:req completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error");
            return;
        }
        NSData *c = [NSData dataWithContentsOfURL:location];
        blockName([[NSString alloc] initWithData:c encoding:NSUTF8StringEncoding]);
    }];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

}

@end
