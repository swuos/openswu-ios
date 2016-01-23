//
//  GradesTableViewHeaderView.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/22.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewHeaderView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Router.h"

@interface GradesTableViewHeaderView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerViewOne;
@property (nonatomic, strong) NSMutableArray *arry;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic) NSInteger *year;
@property (nonatomic) NSInteger *sem;


@end

@implementation GradesTableViewHeaderView


- (instancetype)init {
    self = [super init];
    if (self) {
        NSRange range = NSMakeRange(2,4);
        NSString *year = [[[Router sharedInstance] SWUID] substringWithRange:range];
        self.arry = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            [self.arry addObject:[NSString stringWithFormat:@"%d~%d",[year intValue]+i,[year intValue]+1+i]];
        }
        self.frame = CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 200);
        [self addSubview:self.pickerViewOne];
        [self addSubview:self.queryButton];
        [self addSubview:self.logoutButton];
    }
    return self;
}

- (UIPickerView *)pickerViewOne {
    if (!_pickerViewOne) {
        _pickerViewOne = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 180)];
        _pickerViewOne.delegate = self;
        _pickerViewOne.dataSource = self;
    }
    return _pickerViewOne;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _logoutButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2, 180, [[UIScreen mainScreen] bounds].size.width/2, 20);
        [_logoutButton setTitle:@"退出" forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

- (UIButton *)queryButton {
    if (!_queryButton) {
        _queryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _queryButton.frame = CGRectMake(0, 180, [[UIScreen mainScreen] bounds].size.width/2, 20);
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton addTarget:self action:@selector(queryGrades) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}

- (void)logout {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC.presentedViewController;
    [topVC dismissViewControllerAnimated:true completion:^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userkey"];
    }];
}

- (void)queryGrades {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:true];
    hud.labelText = @"正在查询";
    [hud show:true];
    
    if ([[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] count] < 2) {
        NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"userkey"];
        [[Router sharedInstance] loginWithName:name AndPassword:password AndCompletionHandler:^(NSString *s) {
            
        }];
    };
    
    NSInteger xn = [self.pickerViewOne selectedRowInComponent:0];
    NSInteger xq = [self.pickerViewOne selectedRowInComponent:1];
    [[Router sharedInstance] getGradesInXN:[self.arry[xn] substringWithRange:NSMakeRange(0,4)] andXQ:[NSString stringWithFormat:@"%ld", xq+1] AndCompletionHandler:^(NSString *s) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:true];
            });
    }];
}

#pragma mark picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width/2, 100);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.arry[row];
    } else {
        return [NSString stringWithFormat:@"%ld", row + 1];
    }
}

@end
