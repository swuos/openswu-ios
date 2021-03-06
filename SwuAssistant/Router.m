//
//  Router.m
//  SwuAssistant
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "Router.h"
#import "Course.h"

@interface Router() 

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
    
    NSString *hostString = @"urp6.swu.edu.cn";
    NSString *pathString = @"/userPasswordValidate.portal";
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[self urlWitHost:hostString
                                                                                    Path:pathString
                                                                              Parameters:nil]];
    [req setHTTPMethod:@"POST"];
    [req setTimeoutInterval:1.5f];
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
              CompletionHandler:(void(^)(NSArray *))block{
//    NSString *urlString0 = @"http://jw.swu.edu.cn/jwglxt/idstar/index.jsp";
//    NSString *urlString1 = @"http://jw.swu.edu.cn/jwglxt/xtgl/index_initMenu.html";
    
    NSString *hostString = @"jw.swu.edu.cn";
    NSString *pathString1 = @"/jwglxt/idstar/index.jsp";
    NSString *pathString2 = @"/jwglxt/xtgl/index_initMenu.html";


    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request0 = [[NSMutableURLRequest alloc] initWithURL:[self urlWitHost:hostString
                                                                                         Path:pathString1
                                                                                   Parameters:nil]];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL:[self urlWitHost:hostString
                                                                                         Path:pathString2
                                                                                   Parameters:nil]];

    NSURLSessionTask *task1 = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
            block(@[error]);
            
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        
        NSRange position = [string rangeOfString:@"<input type=\"hidden\" id=\"sessionUserKey\" value=\""];
        if (position.length <= 0) {
            NSError *error = [NSError errorWithDomain:@"the server has some trouble" code:2 userInfo:nil];
            block(@[error]);
            return;
        }
        
        position.location += position.length;
        position.length = 15;
        NSString *userKey = [string substringWithRange:position];
        
        self.SWUID = userKey;
        
        [self getGradesDicInAcademicYear:year andSemester:semester CompletionHandler:block];
        
    }];
    
    NSURLSessionTask *task0 = [session dataTaskWithRequest:request0 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block(@[error]);
            return;
        }
        [task1 resume];
    }];
    
    [task0 resume];

}

- (void)getGradesDicInAcademicYear:(NSString *)xn
                       andSemester:(NSString *)xq
                 CompletionHandler:(void(^)(NSArray *))block{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *xqstr = [xq  isEqual: @"1"] ?  @"3": @"12";

    NSString *hostString = @"jw.swu.edu.cn";
    NSString *pathString = @"/jwglxt/cjcx/cjcx_cxDgXscj.html";
    NSDictionary *para = @{@"gnmkdmKey"             : @"N253508",
                           @"sessionUserKey"        : self.SWUID,
                           @"doType"                : @"query",
                           @"xnm"                   : xn,
                           @"xqm"                   : xqstr,
                           @"_search"               : @"false",
                           @"nd"                    : @"1453455899708",
                           @"queryModel.showCount"  :@"30",
                           @"queryModel.currentPage":@"1",
                           @"queryModel.sortName"   : @"",
                           @"queryModel.sortOrder"  :@"asc",
                           @"time"                  :@"0"};
    
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [self urlWitHost:hostString
                                                                                          Path:pathString
                                                                                    Parameters:para]];
    
    NSURLSessionTask *task2 = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            block(@[error]);
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        block(dict[@"items"]);
    }];
    [task2 resume];
}

- (void)fetchCourseContentsCompletionHandler:(void(^)(NSArray *))block {
    NSString *hostString = @"jw.swu.edu.cn";
    NSString *pathString = @"/jwglxt/kbcx/xskbcx_cxXsKb.html";
    NSDictionary *para = @{@"gnmkdmKey": @"N253508",
                           @"sessionUserKey": self.SWUID};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self urlWitHost:hostString
                                                                                   Path:pathString
                                                                             Parameters:para]];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *string = [NSString stringWithFormat:@"xnm=%@&xqm=%@", [self getCurrentYear], [self getCurrentSemester]];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            Course *course = [[Course alloc] init];
            course.courseName = error.localizedDescription;
            block(@[course]);
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

- (NSString *)getCurrentYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger y = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger m = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];

    if (m <= 7) {
        y -= 1;
    }
    
    return [NSString stringWithFormat:@"%ld", (long)y];
}

- (NSString *)getCurrentSemester {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger c = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
    if (c >= 9) {
        return @"3";
    } else {
        return @"12";
    }
}


#pragma mark - helper method 

- (NSURL *)urlWitHost:(NSString *) host Path:(NSString *)path Parameters:(NSDictionary *) para {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.host = host;
    urlComponents.scheme = @"http";
    urlComponents.path = path;
    
    NSMutableArray *arry = [[NSMutableArray alloc] initWithCapacity:para.count];
    
    for (NSString *key in para) {
        NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key value:para[key]];
        [arry addObject:item];
    }
    urlComponents.queryItems = arry;
    
    return urlComponents.URL;
}

@end
