//
//  Course.m
//  SwuAssistant
//
//  Created by Kric on 2/28/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "Course.h"

@implementation Course

+ (Course *)courseWithName:(NSString *)courseName Time:(NSString *)courseTime Week:(NSString *)courseWeek Teacher:(NSString *)courseTeacher Classroom:(NSString *)courseClassroom WeekNumber:(NSString *)weekNumber {
    Course *newCourse = [[Course alloc] init];
    newCourse.courseName = courseName;
    newCourse.courseTime = courseTime;
    newCourse.courseWeekDay = courseWeek;
    newCourse.courseTeacher = courseTeacher;
    newCourse.courseClassroom = courseClassroom;
    newCourse.courseWeekNumber = weekNumber;
    return newCourse;
}

- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"name:%@ time:%@ week:%@ teacher:%@ classroom:%@", self.courseName, self.courseTime, self.courseWeekDay, self.courseTeacher, self.courseClassroom];
    return descriptionString;
}

@end
