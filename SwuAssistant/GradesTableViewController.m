//
//  GradesTableViewController.m
//  SwuAssistant
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewController.h"
#import "GradesTableViewHeaderView.h"
#import "GradesTableViewCell.h"
#import "Router.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface GradesTableViewController ()

@property (nonatomic, strong) NSArray *dict;
@property (nonatomic, strong) GradesTableViewHeaderView *header;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation GradesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.header = [[GradesTableViewHeaderView alloc] init];
    [self.header setTarget:self Action:@selector(fetchGrades) ContorlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView: self.header];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView  registerClass:[GradesTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    self.dict = @[];
}

- (void)fetchGrades {
    NSArray *time = self.header.currentSelection;
    [self.hud show: true];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"";
    [[Router sharedInstance] getGradesInAcademicYear: time[0] Semester:time[1] CompletionHandler:^(NSArray *s) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // if there is only one result, may be there are some trouble.
            if (s.count == 1) {
                if ([s[0] isKindOfClass:[NSError class]]) {
                    NSError *error = s[0];
                    self.hud.labelText = error.localizedDescription;
                    self.hud.mode = MBProgressHUDModeText;
                    [self.hud hide:true afterDelay:1.0f];
                    return;
                }
            }
            
            [self.hud hide:YES];
            self.dict = s;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dict count] != 0 ? [self.dict count] +  1 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if ([self.dict count] == 0) {
        cell.courseName.text = @"这学期还没有成绩哦。";
        cell.coursePoint.text = @"";
        cell.courseGrade.text = @"";
        return cell;
    }
    if (indexPath.row == 0) {
        cell.courseName.text = @"课程名称";
        cell.courseGrade.text = @"成绩";
        cell.coursePoint.text = @"学分";
    } else {
        cell.courseName.text = self.dict[indexPath.row-1][@"kcmc"];
        cell.courseGrade.text = self.dict[indexPath.row-1][@"cj"];
        cell.coursePoint.text = self.dict[indexPath.row-1][@"xf"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

# pragma mark - getters 

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview:_hud];
    }
    return _hud;
}
@end
