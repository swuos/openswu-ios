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
    
    self.dict = @[@""];
}

#pragma mark - The Refresh Delegate
- (void)updateDataWithArray:(NSArray *)dict {
    self.dict = dict;
    if(!dict) {
        NSLog(@"Null");
    } else {
        NSLog(@"%lu", (unsigned long)dict.count);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dict count] != 0 ? [self.dict count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if ([self.dict count] == 0) {
        cell.kcmc.text = @"这学期还没有成绩哦。";
        return cell;
    }
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
