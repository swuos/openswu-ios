//
//  Router.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "Router.h"

@interface Router() <NSURLSessionDelegate, NSURLSessionDataDelegate>

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

- (void)loginWithName:(NSString *)name AndPassword:(NSString *)password AndCompletionHandler:(void (^)(NSString *))completionBlock {
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
            completionBlock(@"failed");
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userkey"];
        NSData *c = [NSData dataWithContentsOfURL:location];
        NSString *string =[[NSString alloc] initWithData:c encoding:NSUTF8StringEncoding];
        if ([string containsString:@"handleLoginSuccessed()"]) {
            completionBlock(@"successed");
        } else {
            completionBlock(@"failed");
        }
    }];
    [task resume];
}

- (void)getGradesInXN:(NSString *)xn andXQ:(NSString *)xq AndCompletionHandler:(void(^)(NSString *))block{
    
    NSString *urlString0 = @"http://jw.swu.edu.cn/jwglxt/idstar/index.jsp";
    NSString *urlString1 = @"http://jw.swu.edu.cn/jwglxt/xtgl/index_initMenu.html";

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request0 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString0]];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString1]];

    NSURLSessionTask *task1 = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSLog(@"%@", response);
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!string) {
            return;
        }
        NSRange position = [string rangeOfString:@"<input type=\"hidden\" id=\"sessionUserKey\" value=\""];
        position.location += position.length;
        position.length = 15;
        NSString *userKey = [string substringWithRange:position];
        self.SWUID = userKey;
        [self getGradesDicInXN:xn andXQ:xq];
        block(@"successed");
    }];
    
    NSURLSessionTask *task0 = [session dataTaskWithRequest:request0 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [task1 resume];
    }];
    
    [task0 resume];

}

- (void)getGradesDicInXN:(NSString *)xn andXQ:(NSString *)xq {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *str = [xq  isEqual: @"1"] ?  @"3": @"12";
    NSString *urlString = [NSString stringWithFormat:@"http://jw.swu.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html?doType=query&gnmkdmKey=N305005&sessionUserKey=%@&xnm=%@&xqm=%@&_search=false&nd=1453455799708&queryModel.showCount=30&queryModel.currentPage=1&queryModel.sortName=&queryModel.sortOrder=asc&time=0",self.SWUID, xn, str];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionTask *task2 = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self.delegate updateDataWithDict:dict[@"items"]];
    }];
    [task2 resume];
}

@end
