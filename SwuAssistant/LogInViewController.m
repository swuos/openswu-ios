//
//  LogInViewController.m
//  SwuAssistant
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "LogInViewController.h"
#import "Router.h"
#import "GradesTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MainTableViewController.h"

@interface LogInViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *userpassword;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float p = [[UIScreen mainScreen] bounds].size.height / 320.0;
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    
    UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
    v.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:v];
    UITapGestureRecognizer *gg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTheKeyBoard)];
    [v addGestureRecognizer:gg];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    img.frame = CGRectMake(50, 50, 100, 100);
    img.center = self.view.center;
    CGRect rect = img.frame;
    rect.origin.y = 50*p;
    img.frame = rect;
    
    [self.view addSubview:img];
    
    _username=[[UITextField alloc] initWithFrame:CGRectMake(20, 140*p, self.view.frame.size.width-40, 50)];
    _username.backgroundColor=[UIColor whiteColor];
    _username.placeholder=[NSString stringWithFormat:@"账户"];
    _username.layer.cornerRadius = 5.0;
    [self.view addSubview:_username];
    
    _userpassword=[[UITextField alloc] initWithFrame:CGRectMake(20, 140*p + 60, self.view.frame.size.width-40, 50)];
    _userpassword.backgroundColor=[UIColor whiteColor];
    _userpassword.placeholder=[NSString stringWithFormat:@"密码"];
    [_userpassword setSecureTextEntry:true];
    _userpassword.layer.cornerRadius = 5.0;
    [self.view addSubview:_userpassword];
    
    _loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setFrame:CGRectMake(20, 140*p+120, self.view.frame.size.width-40, 50)];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:51/255.0 green:102/255.0 blue:255/255.0 alpha:1]];

    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 5.0;
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    
    _username.delegate = self;
    _userpassword.delegate = self;
}

- (void)hideTheKeyBoard {
    [self.userpassword resignFirstResponder];
    [self.username resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    _username.text = @"";
    _userpassword.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)login {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.username.text  isEqual: @""] || [self.userpassword.text  isEqual: @""]) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户名和密码不能留空";
        [hud show:true];
        [hud hide:true afterDelay:2];
        return;
    }
    hud.labelText = @"Loading";
    [hud show:true];
    
    [[Router sharedInstance] loginWithName:self.username.text Password:self.userpassword.text CompletionHandler:^(NSString *cc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:true];
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;

            if ([cc containsString:@"successed"]) {
                hud.labelText = @"登录成功😬";
                [[Router sharedInstance] getGradesInAcademicYear:@"2013" Semester:@"1" CompletionHandler:^(NSString *s) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                        }];

                    });
                }];
            } else {
                hud.labelText = @"请检查账户和密码名🤔";
            }
            
            [hud show:true];
            [hud hide:true afterDelay:2];
        });
    }];
}

#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideTheKeyBoard];
    return true;
}

@end
