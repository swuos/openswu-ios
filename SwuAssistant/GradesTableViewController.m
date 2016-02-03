//
//  GradesTableViewController.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewController.h"
#import "GradesTableViewHeaderView.h"
#import "GradesTableViewCell.h"
#import "Router.h"

@interface GradesTableViewController ()<updateData>

@property (nonatomic, strong) NSArray *dict;

@end

@implementation GradesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dict = @[];
    [self.tableView setTableHeaderView:[[GradesTableViewHeaderView alloc] init]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView  registerClass:[GradesTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [Router sharedInstance].delegate = self;
}

#pragma mark - The Refresh Delegate
- (void)updateDataWithDict:(NSArray *)dict {
    self.dict = dict;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dict count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.kcmc.text = @"课程名称";
        cell.cj.text = @"成绩";
        cell.xf.text = @"学分";
    } else {
        cell.kcmc.text = self.dict[indexPath.row][@"kcmc"];
        cell.cj.text = self.dict[indexPath.row][@"cj"];
        cell.xf.text = self.dict[indexPath.row][@"xf"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}



@end
