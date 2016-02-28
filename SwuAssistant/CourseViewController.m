//
//  CourseViewController.m
//  SwuAssistant
//
//  Created by Kric on 2/28/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "CourseViewController.h"
#import "Course.h"

@interface CourseViewController ()

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fetchCourseContents];
}


- (void)fetchCourseContents {
    NSString *url = @"http://jw.swu.edu.cn/jwglxt/kbcx/xskbcx_cxXsKb.html?gnmkdmKey=N253508&sessionUserKey=222014321210009";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *string = [NSString stringWithFormat:@"xnm=2015&xqm=12"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: nil];
            NSArray *array = dict[@"kbList"];
            for (NSDictionary *d in array) {
                
                NSLog(@"%@ %@ %@ %@", d[@"kcmc"],d[@"zcd"], d[@"xqjmc"], d[@"jc"]);
            }
        }
    }];
    [task resume];
}

@end
