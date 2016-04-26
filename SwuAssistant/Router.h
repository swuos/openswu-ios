//
//  Router.h
//  SwuAssistant
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Course;

@interface Router : NSObject

@property (nonatomic, strong) NSString *SWUID;

+ (Router *)sharedInstance;

- (void)loginWithName:(NSString *)name
             Password:(NSString *)password
    CompletionHandler:(void (^)(NSString *))completionBlock;

- (void)getGradesInAcademicYear:(NSString *)year
                       Semester:(NSString *)semester
              CompletionHandler:(void(^)(NSArray *))block;

- (void)fetchCourseContentsCompletionHandler:(void(^)(NSArray *))block;

@end
