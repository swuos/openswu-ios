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
    NSArray *s = [Course getCourseFromDataBase];
    for (Course *c in s) {
        NSLog(@"%@", [c description]);
    }
    NSLog(@"==========");
    [Course createTable];
    [[Router sharedInstance] fetchCourseContentsCompletionHandler:^(NSArray<Course *> *courses) {
        for (Course *cc in courses) {
            NSLog(@"%@", [cc description]);
        }
    }];
    
    
    dispatch_queue_t myQueue = dispatch_queue_create("com.swu.edu.cn", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_set_target_queue(myQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    
    dispatch_apply(10, myQueue, ^(size_t index) {
        NSLog(@"%zu", index);
    });

}

@end
