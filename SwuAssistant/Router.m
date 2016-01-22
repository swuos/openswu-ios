//
//  Router.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "Router.h"

@interface Router() <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic) NSString *SWUID;

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

- (void)getGrades {
    
    NSString *urlString0 = @"http://jw.swu.edu.cn/jwglxt/idstar/index.jsp";
    NSString *urlString1 = @"http://jw.swu.edu.cn/jwglxt/xtgl/index_initMenu.html";

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request0 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString0]];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString1]];

    NSURLSessionTask *task1 = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange position = [string rangeOfString:@"<input type=\"hidden\" id=\"sessionUserKey\" value=\""];
        position.location += position.length;
        position.length = 15;
        NSString *userKey = [string substringWithRange:position];
        self.SWUID = userKey;
        [self getGradesDic];
    }];
    
    NSURLSessionTask *task0 = [session dataTaskWithRequest:request0 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [task1 resume];
    }];
    
    [task0 resume];

}

- (void)getGradesDic {
    NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString2  = @"http://jw.swu.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html?doType=query&gnmkdmKey=N305005&sessionUserKey=222014321210009&xnm=2015&xqm=&_search=false&nd=1453455799708&queryModel.showCount=15&queryModel.currentPage=1&queryModel.sortName=&queryModel.sortOrder=asc&time=4";
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString2]];
    NSURLSessionTask *task2 = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@",dict[@"items"][0][@"kcmc"]);
        [self.delegate refreshWithDict:dict[@"items"]];
    }];
    [task2 resume];
}

@end