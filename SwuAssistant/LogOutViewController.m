//
//  LogOutViewController.m
//  SwuAssistant
//
//  Created by Kric on 3/18/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "LogOutViewController.h"

NSString *kErrorHTMLString = @"<!DOCTYPE html><html><head><title></title></head><body><p>请检查你是不是连接到了swu-wifi或者swu-dorm-wifi</p></body></html>";

@interface LogOutViewController () <NSURLSessionTaskDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong ,nonatomic) NSURLSession *session;
@property (nonatomic) NSUInteger flag;

@end

@implementation LogOutViewController

- (IBAction)login:(UIButton *)sender {
    NSURL *SWUWifiURL = [NSURL URLWithString:@"http://202.202.96.57:9060/login/login1.jsp"];
    NSURL *DormWifiURL = [NSURL URLWithString:@"http://222.198.120.8:8080/loginPhoneServlet"];
    
    NSMutableURLRequest *wifiRequest = [[NSMutableURLRequest alloc] initWithURL:SWUWifiURL];
    NSMutableURLRequest *dormWifiRequest = [[NSMutableURLRequest alloc] initWithURL:DormWifiURL];
    
    NSString *WifiBody = [NSString stringWithFormat:@"username=%@&password=%@&if_login=&B2=", self.userName.text, self.userPassword.text];
    NSString *dormWifiBody = [NSString stringWithFormat:@"username=%@&password=%@&loginTime=%f", self.userName.text, self.userPassword.text, [[NSDate date] timeIntervalSince1970]];
    
    [wifiRequest setHTTPMethod:@"POST"];
    [wifiRequest setTimeoutInterval:3.f];
    [wifiRequest setHTTPBody:[WifiBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [dormWifiRequest setHTTPMethod:@"POST"];
    [dormWifiRequest setTimeoutInterval:3.f];
    [dormWifiRequest setHTTPBody:[dormWifiBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionTask *task1;
    NSURLSessionTask *task = [self.session downloadTaskWithRequest:wifiRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            self.flag ++;
            return ;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSString *stringDecodingByUTF8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (task1) {
            [task1 cancel];
        }
        NSLog(@"%d", __LINE__);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:stringDecodingByUTF8 baseURL:nil];
        });
        
        
    }];
    [task resume];
    
    task1 = [self.session downloadTaskWithRequest:dormWifiRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            self.flag ++;
            return ;
        }
        NSLog(@"%lld", response.expectedContentLength);
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSString *stringDecodingByUTF8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:stringDecodingByUTF8 baseURL:nil];
        });
        
    }];
    [task1 resume];
    
    NSLog(@"%@", self.session);
}

- (IBAction)logOut:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://service.swu.edu.cn/fee/remote_logout2.jsp"];
    
    NSMutableURLRequest *rq = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@&B1=", self.userName.text, self.userPassword.text];
    
    [rq setHTTPMethod:@"POST"];
    [rq setTimeoutInterval:3.f];
    [rq setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
 
    NSURLSessionTask *task = [self.session downloadTaskWithRequest:rq completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *stringWithGBKEncoding = [[NSString alloc] initWithData:data encoding:encoding];
        if (!stringWithGBKEncoding) {
            stringWithGBKEncoding = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:stringWithGBKEncoding baseURL:nil];
        });

    }];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"];
    self.userName.text = name;
    self.userPassword.text = pass;
    
    self.session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate: self
                                            delegateQueue: nil];
    self.flag = 0;
    NSString *NoticeInfo = @"<!DOCTYPE html><html><head><title></title></head><body><p>请请注意此功能仅当连接到了swu-wifi或者swu-dorm-wifi才能使用</p></body></html>";
    [self.webView loadHTMLString:NoticeInfo baseURL:nil];
}

- (void)setFlag:(NSUInteger )flag {
    _flag = flag;
    if (self.flag == 2) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:kErrorHTMLString baseURL:nil];
        });
    }
}



#pragma mark delegate

@end
