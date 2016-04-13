//
//  LogOutViewController.m
//  SwuAssistant
//
//  Created by Kric on 3/18/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "LogOutViewController.h"

static const NSString *kErrorHTMLString = @"<!DOCTYPE html><html><head><title></title></head><body><h1>请检查你是不是连接到了swu-wifi或者swu-dorm-wifi</h1></body></html>";

@interface LogOutViewController () <NSURLSessionTaskDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong ,nonatomic) NSURLSession *session;
@property (nonatomic) NSUInteger flag;

@end

@implementation LogOutViewController

- (IBAction)login:(UIButton *)sender {
    [self showAlertViewControllerMessage: @"登陆中。。。" WithAction: false];

    NSURL *SWUWifiURL = [NSURL URLWithString:@"http://202.202.96.57:9060/login/login1.jsp"];
    NSURL *DormWifiURL = [NSURL URLWithString:@"http://222.198.120.8:8080/loginPhoneServlet"];
    
    NSMutableURLRequest *wifiRequest = [[NSMutableURLRequest alloc] initWithURL:SWUWifiURL];
    NSMutableURLRequest *dormWifiRequest = [[NSMutableURLRequest alloc] initWithURL:DormWifiURL];
    
    NSString *WifiBody = [NSString stringWithFormat:@"username=%@&password=%@&if_login=&B2=", [self.userName.text lowercaseString], self.userPassword.text];
    NSString *dormWifiBody = [NSString stringWithFormat:@"username=%@&password=%@&loginTime=%f", [self.userName.text lowercaseString], self.userPassword.text, [[NSDate date] timeIntervalSince1970]];
    
    [wifiRequest setHTTPMethod:@"POST"];
    [wifiRequest setTimeoutInterval:3.f];
    [wifiRequest setHTTPBody:[WifiBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [wifiRequest setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
    [dormWifiRequest setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
    
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
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *stringWithGBKEncoding = [[NSString alloc] initWithData:data encoding:encoding];
        [self dismissAlertController];
        
        if ([stringWithGBKEncoding containsString:@"您已通过登录审核"]) {
            [self showAlertViewControllerMessage:@"登陆成功" WithAction: true];
        } else if([stringWithGBKEncoding containsString:@"账号已在其他地方登陆，请退出"]) {
            [self showAlertViewControllerMessage:@"账号已在其他地方登陆，请退出" WithAction: true];
        } else if([stringWithGBKEncoding containsString:@"密码错误"]) {
            [self showAlertViewControllerMessage:@"密码错误" WithAction: true];
        } else {
            [self showAlertViewControllerMessage:@"蜜汁错误" WithAction: true];
        }
        
        [self showMessageInWebView: stringWithGBKEncoding];

    }];
    [task resume];
    
    task1 = [self.session downloadTaskWithRequest:dormWifiRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            self.flag ++;
            return ;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSString *stringDecodingByUTF8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self dismissAlertController];

        [self showMessageInWebView: stringDecodingByUTF8];
        
        if ([stringDecodingByUTF8 containsString:@"登录成功"]) {
            [self showAlertViewControllerMessage:@"登陆成功" WithAction: true];
        } else if([stringDecodingByUTF8 containsString:@"You are already logged in"]) {
            [self showAlertViewControllerMessage:@"账号已在其他地方登陆，请退出" WithAction: true];
        } else if([stringDecodingByUTF8 containsString:@"Password check failed"]) {
            [self showAlertViewControllerMessage:@"密码错误" WithAction: true];
        } else {
            [self showAlertViewControllerMessage:@"蜜汁错误" WithAction: true];
        }
        
    }];
    [task1 resume];
}

- (IBAction)logOut:(UIButton *)sender {
    [self showAlertViewControllerMessage: @"正在退出账号。。。" WithAction: false];
    
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
        
        [self dismissAlertController];
        NSLog(@"%@", stringWithGBKEncoding);
        if ([stringWithGBKEncoding isEqualToString:@""]) {
            [self showAlertViewControllerMessage:@"退出失败" WithAction: true];
            [self showMessageInWebView: (NSString *)kErrorHTMLString];
        } else {
            [self showAlertViewControllerMessage:@"退出成功" WithAction: true];
            [self showMessageInWebView: stringWithGBKEncoding];
        }
    }];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] lowercaseString];
    NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"];
    self.userName.text = name;
    self.userPassword.text = pass;
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configure setRequestCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    self.session = [NSURLSession sessionWithConfiguration: configure
                                                 delegate: nil
                                            delegateQueue: nil];
    self.flag = 0;
    NSString *NoticeInfo = @"<!DOCTYPE html><html><head><title></title></head><body><h1>请请注意此功能仅当连接到了swu-wifi或者swu-dorm-wifi才能使用</h1></body></html>";
    
    
    self.webView.scalesPageToFit = true;
    
    [self showMessageInWebView:NoticeInfo];
    
    [self addObserver: self
           forKeyPath:@"flag"
              options: NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
              context: nil];
}


- (void)showAlertViewControllerMessage:(NSString *)message WithAction:(BOOL)action {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (action) {
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dismissAlertController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated: true completion:^{
        }];
    });
}

- (void)showMessageInWebView:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadHTMLString: message
                             baseURL: nil];
    });
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id value = change[NSKeyValueChangeNewKey];
    if ([value  isEqual: @2]) {
        self.flag = 0;
        [self showMessageInWebView: (NSString *)kErrorHTMLString];
        [self dismissAlertController];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"flag"];
}


@end
