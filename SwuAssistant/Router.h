//
//  Router.h
//  SwuAssistant
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@protocol updateData <NSObject>

- (void)updateDataWithArray:(NSArray *)array;

@end


@interface Router : NSObject

@property (nonatomic, strong) NSString *SWUID;

@property (nonatomic, weak) id<updateData> delegate;

+ (Router *)sharedInstance;

- (void)loginWithName:(NSString *)name Password:(NSString *)password CompletionHandler:(void (^)(NSString *))completionBlock;

- (void)getGradesInAcademicYear:(NSString *)year Semester:(NSString *)semester CompletionHandler:(void(^)(NSString *))block;

- (void)fetchCourseContentsCompletionHandler:(void(^)(NSArray<Course *> *))block;

@end
