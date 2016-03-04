//
//  Course.h
//  SwuAssistant
//
//  Created by Kric on 2/28/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic, strong) NSString *courseName;
@property (nonatomic, strong) NSString *courseTime;
@property (nonatomic, strong) NSString *courseWeek;
@property (nonatomic, strong) NSString *courseTeacher;
@property (nonatomic, strong) NSString *courseClassroom;

+ (Course *)courseWithName:(NSString *)courseName Time:(NSString *)courseTime Week:(NSString *)courseWeek Teacher:(NSString *)courseTeacher Classroom:(NSString *)course;

+(NSArray<Course *> *)getCourseFromDataBase;

+ (void)createTable;


@end
