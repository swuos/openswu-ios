//
//  GradesTableViewController.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewController.h"
#import "Router.h"
#import "GradesTableViewHeaderView.h"

@interface GradesTableViewController ()<refresh>

@property (nonatomic, strong) NSArray *dict;

@end

@implementation GradesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dict = @[];
    [self.tableView setTableHeaderView:[[GradesTableViewHeaderView alloc] init]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [Router sharedInstance].delegate = self;
    [[Router sharedInstance] getGrades];
}

- (void)refreshWithDict:(NSArray *)dict {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.detailTextLabel.text = self.dict[indexPath.row][@"cj"];
    cell.textLabel.text = self.dict[indexPath.row][@"kcmc"];
    
    return cell;
}


@end
