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

@interface CourseViewController ()

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [Course createTable];
    [[Router sharedInstance] fetchCourseContentsCompletionHandler:^(NSArray<Course *> *courses) {
        for (Course *cc in courses) {
            NSLog(@"%@", [cc description]);
        }
    }];
}

@end
