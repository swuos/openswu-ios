//
//  LogOutViewController.m
//  SwuAssistant
//
//  Created by Kric on 3/18/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "LogOutViewController.h"
#import "AccountLogInOut.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LogOutViewController () <NSURLSessionTaskDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (nonatomic, strong) AccountLogInOut *logManager;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation LogOutViewController

- (IBAction)login:(UIButton *)sender {
    [self.hud show: true];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"正在登陆";
    
    [self.logManager logInWithCompletionBlock:^(NSString *cString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = cString;
            self.hud.labelText = cString;
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hide:true afterDelay:1.5f];
        });
    } FailureBlock:^(NSString *fString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = fString;
            self.hud.labelText = fString;
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hide:true afterDelay:1.5f];
        });
    }];
}

- (IBAction)logOut:(UIButton *)sender {
    [self.hud show: true];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"正在登陆";
    
    [self.logManager logOutWithCompletionBlock:^(NSString *completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = completion;
            self.hud.labelText = completion;
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hide:true afterDelay:1.5f];
        });
    } FailureBlock:^(NSString *failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.labelText = failure;
            self.resultLabel.text = failure;
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hide:true afterDelay:1.5f];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] lowercaseString];
    NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"];
    self.userName.text = name;
    self.userPassword.text = pass;
}

- (AccountLogInOut *)logManager {
    if (!_logManager) {
        _logManager = [[AccountLogInOut alloc] initWithUsername:self.userName.text Userpass:self.userPassword.text];
    } else {
        _logManager.username = self.userName.text;
        _logManager.userpass = self.userPassword.text;
    }
    return _logManager;
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview:_hud];
    }
    return _hud;
}

@end
