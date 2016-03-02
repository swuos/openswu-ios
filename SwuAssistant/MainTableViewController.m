//
//  MainTableViewController.m
//  SwuAssistant
//
//  Created by Kric on 16/2/3.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "MainTableViewController.h"
#import "GradesTableViewController.h"
#import "LogInViewController.h"
#import "CourseViewController.h"
#import "CourseCollectionViewController.h"
#import "Router.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SAUser.h"

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray<NSString *> *strings;
@property (nonatomic) NSInteger *count;

@end

@implementation MainTableViewController

- (void)testSAUser {
    [SAUser saveModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testSAUser];
    self.count = 0;
    [self configureNavigationBarItem];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"abc"];
    [self.tableView setTableFooterView:[UIView new]];
    self.title = @"首页";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    if ([self checkIfLoggedIn]) {
        if (self.count == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"loading";
            [hud show:YES];
            [self fetchInfo];
            _count++;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self checkIfLoggedIn]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请登录";
        [hud show:YES];
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    UIViewController *controller;
    if (indexPath.row == 2) {
//        UICollectionViewController *c = [[CourseCollectionViewController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
//        controller = c;
        controller = [[CourseViewController alloc] init];
    } else {
        controller = [[GradesTableViewController alloc] init];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        if ([self checkIfLoggedIn]) {
            cell.textLabel.text = [NSString stringWithFormat:@"账号%@已登陆",[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
        } else {
            cell.textLabel.text = @"请点击左上角登陆";
        }
    } else {
        cell.textLabel.text = self.strings[indexPath.row - 1];
    }
    return cell;
}

- (NSArray<NSString *> *)strings {
    return @[@"成绩查询", @"课表"];
}

- (void)fetchInfo {
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *userpassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"userkey"];
    
    [[Router sharedInstance] loginWithName:username Password:userpassword CompletionHandler:^(NSString *cc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([cc containsString:@"successed"]) {
                [[Router sharedInstance] getGradesInAcademicYear:@"2014" Semester:@"1" CompletionHandler:^(NSString *s) {
                    //Anyway after request has been handled, the hud should be hidden?
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:true];
                        
                        if (![s containsString:@"successed"]) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:true];
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = s;
                            [hud show:YES];
                            [hud hide:YES afterDelay:1.5f];
                        }
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:true];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"网络连接失败";
                    [hud show:YES];
                    [hud hide:YES afterDelay:1.5f];
                });
            }
        });
    }];
}

- (void)configureNavigationBarItem {
    NSString *title = [self checkIfLoggedIn] ? @"登出" : @"登陆";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(logIn)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)logIn {
    if ([self checkIfLoggedIn]) {
        NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"账号%@已登出", name];
        [hud show:YES];
        [hud hide:YES afterDelay:0.5f];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userkey"];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(logIn)];
        [self.navigationItem setLeftBarButtonItem:leftItem];
        [self.tableView reloadData];
        return;
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(logIn)];
    [self presentViewController:[[LogInViewController alloc] init] animated:YES completion:^{
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }];
}

- (BOOL)checkIfLoggedIn {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"username"]) {
        return NO;
    } else {
        return YES;
    }
}

@end
