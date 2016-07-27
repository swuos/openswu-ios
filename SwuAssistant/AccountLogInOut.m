//
//  AccountLogInOut.m
//  SwuAssistant
//
//  Created by Kric on 4/26/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "AccountLogInOut.h"

@interface AccountLogInOut()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation AccountLogInOut

- (instancetype)init {
    return [self initWithUsername:@"" Userpass:@""];
}

- (instancetype)initWithUsername:(NSString *)username Userpass:(NSString *)userpass {
    self = [super init];
    if (self) {
        self.username = username;
        self.userpass = userpass;
        self.session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)logInWithCompletionBlock:(completionblock)ComBlock FailureBlock:(completionblock)FailureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        __block int flag = 0;
        __block NSString *tmp = @"";
        [self logInClassCompletionBlock: ^(NSString *c) {
            flag = 1;
            ComBlock(@"登录成功");
            dispatch_semaphore_signal(sem);
        } FailureBlock:^(NSString *f) {
            flag = 0;
            tmp = f;
            dispatch_semaphore_signal(sem);
        }];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        if (flag == 1) {
            return;
        }
        if ((![tmp containsString:@"未知错误"] && ![tmp containsString:@"登录失败"])) {
            FailureBlock(tmp);
        }
        [self logInDormCompletionBlock:^(NSString *c) {
            ComBlock(@"登录成功");
        } FailureBlock:^(NSString *f) {
            FailureBlock(f);
        }];
    });
}

- (void)logInDormCompletionBlock:(completionblock)ComBlock FailureBlock:(completionblock)FailureBlock {
    NSURL *DormWifiURL = [NSURL URLWithString:@"http://222.198.120.8:8080/loginPhoneServlet"];
    NSMutableURLRequest *dormWifiRequest = [[NSMutableURLRequest alloc] initWithURL:DormWifiURL
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                    timeoutInterval:3.f];
    NSString *dormWifiBody = [NSString stringWithFormat:@"username=%@&password=%@&loginTime=%f", [self.username lowercaseString], self.userpass, [[NSDate date] timeIntervalSince1970]];
    [dormWifiRequest setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
    
    [dormWifiRequest setHTTPMethod:@"POST"];
    [dormWifiRequest setTimeoutInterval:3.f];
    [dormWifiRequest setHTTPBody:[dormWifiBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionTask *task = [self.session downloadTaskWithRequest:dormWifiRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            FailureBlock(@"登陆异常");
            return ;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSString *stringDecodingByUTF8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([stringDecodingByUTF8 containsString:@"登录成功"]) {
            
        } else if([stringDecodingByUTF8 containsString:@"You are already logged in"]) {
            FailureBlock(@"你已经登陆了");
        } else if([stringDecodingByUTF8 containsString:@"Password check failed"]) {
            FailureBlock(@"密码错误");
        } else if([stringDecodingByUTF8 containsString:@"登陆异常"]){
            FailureBlock(@"有可能你登陆成功了。。。");
        } else {
            FailureBlock(@"蜜汁错误");
        }
        
    }];
    [task resume];
}

- (void)logInClassCompletionBlock:(completionblock)ComBlock FailureBlock:(completionblock)FailureBlock {
    NSURL *SWUWifiURL = [NSURL URLWithString:@"http://202.202.96.57:9060/login/login1.jsp"];
    
    NSMutableURLRequest *wifiRequest = [[NSMutableURLRequest alloc] initWithURL:SWUWifiURL
                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                timeoutInterval:3.f];
    
    NSString *WifiBody = [NSString stringWithFormat:@"username=%@&password=%@&if_login=&B2=", [self.username lowercaseString], self.userpass];
    
    [wifiRequest setHTTPMethod:@"POST"];
    [wifiRequest setTimeoutInterval:3.f];
    [wifiRequest setHTTPBody:[WifiBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [wifiRequest setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
    
    
    NSURLSessionTask *task = [self.session downloadTaskWithRequest:wifiRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            FailureBlock(@"登录失败");
            return ;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *stringWithGBKEncoding = [[NSString alloc] initWithData:data encoding:encoding];
        
        if ([stringWithGBKEncoding containsString:@"您已通过登录审核"]) {
            ComBlock(@"登录成功");
        } else if([stringWithGBKEncoding containsString:@"账号已在其他地方登陆，请退出"]) {
            FailureBlock(@"账号已在其他地方登陆，请退出");
        } else if([stringWithGBKEncoding containsString:@"密码错误"]) {
            FailureBlock(@"密码错误");
        } else {
            FailureBlock(@"未知错误");
        }
    }];
    [task resume];
}


- (void)logOutWithCompletionBlock:(completionblock)ComBlock FailureBlock:(completionblock)FailureBlock {
    
    NSURL *url = [NSURL URLWithString:@"http://service.swu.edu.cn/fee/remote_logout2.jsp"];
    
    NSMutableURLRequest *rq = [[NSMutableURLRequest alloc] initWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:3.f];
    
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@&B1=", self.username, self.userpass];
    
    [rq setHTTPMethod:@"POST"];
    [rq setTimeoutInterval:3.f];
    [rq setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionTask *task = [self.session downloadTaskWithRequest:rq completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            FailureBlock(error.localizedDescription);
            return;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *stringWithGBKEncoding = [[NSString alloc] initWithData:data encoding:encoding];
        
        ComBlock(stringWithGBKEncoding);
    }];
    
    [task resume];
}


@end
