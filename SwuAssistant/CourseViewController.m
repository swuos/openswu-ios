//
//  CourseViewController.m
//  SwuAssistant
//
//  Created by Kric on 2/28/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "CourseViewController.h"
#import "Course.h"
#import "Router.h"
#import "CourseTableViewCell.h"

@interface CourseViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <Course *> *courses;

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HelloCell"];
    
    [[Router sharedInstance] fetchCourseContentsCompletionHandler:^(NSArray<Course *> *course) {
        self.courses = course;
    }];
    
}

- (void)setCourses:(NSArray<Course *> *)courses {
    _courses = courses;
    [Course createTable];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelloCell" forIndexPath:indexPath];
    if (!cell) {
        
    }
    cell.courseTeacherLabel.text = self.courses[indexPath.row + indexPath.section * 8].courseClassroom;
    cell.courseNameLabel.text = self.courses[indexPath.row + indexPath.section * 8].courseName;
    cell.courseSectionLabel.text = [self.courses[indexPath.row + indexPath.section * 8].courseWeekNumber stringByAppendingString:self.courses[indexPath.row + indexPath.section * 8].courseTime];
    cell.courseWeekLabel.text = self.courses[indexPath.row + indexPath.section * 8].courseWeekDay;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
