//
//  Router.m
//  SwuAssistant
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "Router.h"

@interface Router() <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation Router

#pragma mark - singleton
+ (Router *)sharedInstance {
    static Router *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Router alloc] init];
    });
    return share;
}

#pragma mark - network method
- (void)loginWithName:(NSString *)name
             Password:(NSString *)password
    CompletionHandler:(void (^)(NSString *))completionBlock {
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://urp6.swu.edu.cn/userPasswordValidate.portal"]];
    [req setHTTPMethod:@"POST"];
    // HTTP body
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
            completionBlock([NSString stringWithFormat:@"%@", error.localizedDescription]);
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userkey"];
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSString *string =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([string containsString:@"handleLoginSuccessed()"]) {
            completionBlock(@"successed");
        } else {
            completionBlock(@"failed");
        }
    }];
    [task resume];
}

- (void)getGradesInAcademicYear:(NSString *)year
                       Semester:(NSString *)semester
              CompletionHandler:(void(^)(NSString *))block{
    
    NSString *urlString0 = @"http://jw.swu.edu.cn/jwglxt/idstar/index.jsp";
    NSString *urlString1 = @"http://jw.swu.edu.cn/jwglxt/xtgl/index_initMenu.html";

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request0 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString0]];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString1]];

    NSURLSessionTask *task1 = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block([NSString stringWithFormat:@"%@", error.localizedDescription]);
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!string) {
            block(@"the server has some trouble");
            return;
        }
        
        NSRange position = [string rangeOfString:@"<input type=\"hidden\" id=\"sessionUserKey\" value=\""];
        if (position.length <= 0) {
            block(@"the server has some trouble");
            return;
        }
        
        position.location += position.length;
        position.length = 15;
        NSString *userKey = [string substringWithRange:position];
        
        self.SWUID = userKey;
        
        [self getGradesDicInAcademicYear:year andSemester:semester];
        
        block(@"successed");
    }];
    
    NSURLSessionTask *task0 = [session dataTaskWithRequest:request0 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block([NSString stringWithFormat:@"%@", error.localizedDescription]);
            return;
        }
        [task1 resume];
    }];
    
    [task0 resume];

}

- (void)getGradesDicInAcademicYear:(NSString *)xn
                       andSemester:(NSString *)xq {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *xqstr = [xq  isEqual: @"1"] ?  @"3": @"12";
    
    NSString *urlString = [NSString stringWithFormat:@"http://jw.swu.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html?doType=query&gnmkdmKey=N305005&sessionUserKey=%@&xnm=%@&xqm=%@&_search=false&nd=1453455899708&queryModel.showCount=30&queryModel.currentPage=1&queryModel.sortName=&queryModel.sortOrder=asc&time=0",self.SWUID, xn, xqstr];
    
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionTask *task2 = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self.delegate updateDataWithArray:@[@"fail"]];
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self.delegate updateDataWithArray:dict[@"items"]];
    }];
    [task2 resume];
}

- (void)fetchCourseContentsCompletionHandler:(void(^)(NSArray<Course *> *))block {
    NSString *url = [NSString stringWithFormat:@"http://jw.swu.edu.cn/jwglxt/kbcx/xskbcx_cxXsKb.html?gnmkdmKey=N253508&sessionUserKey=%@", self.SWUID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    // this should be changed for more convience
    NSString *string = [NSString stringWithFormat:@"xnm=2015&xqm=12"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: nil];
            NSArray *array = dict[@"kbList"];
            NSMutableArray <Course *> *courses = [[NSMutableArray alloc] init];
            for (NSDictionary *d in array) {
                Course *c = [Course courseWithName:d[@"kcmc"] Time:d[@"jc"] Week:d[@"xqjmc"] Teacher:d[@"xm"] Classroom:d[@"cdmc"] WeekNumber:d[@"zcd"]];
                [courses addObject:c];
            }
            block(courses);
        }
    }];
    [task resume];
}

@end
