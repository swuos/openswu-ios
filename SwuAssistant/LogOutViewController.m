//
//  LogOutViewController.m
//  SwuAssistant
//
//  Created by Kric on 3/18/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "LogOutViewController.h"

@interface LogOutViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@end

@implementation LogOutViewController

- (IBAction)logOut:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://service.swu.edu.cn/fee/remote_logout2.jsp"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *rq = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"username=%@&password=%@&B1=", self.userName.text, self.userPassword.text];
    
    [rq setHTTPMethod:@"POST"];
    [rq setTimeoutInterval:10.f];
    [rq setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:rq
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"%@", response);
                                            NSLog(@"%@", error);
    } ];
    
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"];
    self.userName.text = name;
    self.userPassword.text = pass;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
