//
//  LogInViewController.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "LogInViewController.h"
#import "Router.h"
#import "GradesTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry.h>


@interface LogInViewController ()

@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *userpassword;
@property (strong, nonatomic) UIButton *loginButton;


@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.username];
    [self.view addSubview:self.userpassword];
    [self.view addSubview:self.loginButton];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(10);
        make.top.equalTo(self.view).with.offset(60);
        make.trailing.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@50);
    }];
    
    [self.userpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(10);
        make.top.equalTo(self.username.mas_bottom).with.offset(40);
        make.trailing.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@50);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.username.text = @"x352389286";
    self.userpassword.text = @"123456";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)login {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    [hud show:true];
    [[Router sharedInstance] loginWithName:self.username.text AndPassword:self.userpassword.text AndCompletionHandler:^(NSString *cc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:true];
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;

            if ([cc containsString:@"handleLoginSuccessed()"]) {
                hud.labelText = @"Successed";
            } else {
                hud.labelText = @"Failed";
            }
        
            [hud show:true];
            [hud hide:true afterDelay:2];
            if ([cc containsString:@"handleLoginSuccessed()"]) {
                [self presentViewController:[[GradesTableViewController alloc] init] animated:true completion:^{
                    
                }];
            }

        });
    }];
}

#pragma mark - getters

- (UITextField *)username {
    if (!_username) {
        _username = [[UITextField alloc] init];
        _username.placeholder = @"accounts";
    }
    return _username;
}

- (UITextField *)userpassword {
    if (!_userpassword) {
        _userpassword = [[UITextField alloc] init];
        _userpassword.placeholder = @"password";
    }
    return _userpassword;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}


@end
