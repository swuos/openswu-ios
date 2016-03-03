//
//  Course.m
//  SwuAssistant
//
//  Created by Kric on 2/28/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "Course.h"
#import <FMDB/FMDB.h>

@implementation Course

+ (Course *)courseWithName:(NSString *)courseName Time:(NSString *)courseTime Week:(NSString *)courseWeek Teacher:(NSString *)courseTeacher Classroom:(NSString *)courseClassroom {
    Course *newCourse = [[Course alloc] init];
    newCourse.courseName = courseName;
    newCourse.courseTime = courseTime;
    newCourse.courseWeek = courseWeek;
    newCourse.courseTeacher = courseTeacher;
    newCourse.courseClassroom = courseClassroom;
    [newCourse saveCourse:newCourse];
    return newCourse;
}

+ (Course *)courseWithoutDBWithName:(NSString *)courseName Time:(NSString *)courseTime Week:(NSString *)courseWeek Teacher:(NSString *)courseTeacher Classroom:(NSString *)courseClassroom {
    Course *newCourse = [[Course alloc] init];
    newCourse.courseName = courseName;
    newCourse.courseTime = courseTime;
    newCourse.courseWeek = courseWeek;
    newCourse.courseTeacher = courseTeacher;
    newCourse.courseClassroom = courseClassroom;
    return newCourse;
}


+ (NSArray<Course *> *)getCourseFromDataBase {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"course.db"];
    
    FMDatabase *db =[FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        return false;
    }
    
    NSString *sqlString = @"select * from course";
    
    FMResultSet *result = [db executeQuery:sqlString];
    
    NSMutableArray <Course *> *queryResult = [[NSMutableArray alloc] init];
    
    while ([result next]) {
        NSString *courseName = [result stringForColumn:@"courseName"];
        NSString *courseTime = [result stringForColumn:@"courseTime"];
        NSString *courseWeek = [result stringForColumn:@"courseWeek"];
        NSString *courseTeacher = [result stringForColumn:@"courseTeacher"];
        NSString *courseClassroom = [result stringForColumn:@"courseClassroom"];
        
        [queryResult addObject:[Course courseWithoutDBWithName:courseName Time:courseTime Week:courseWeek Teacher:courseTeacher Classroom:courseClassroom]];
        
    }
    
    [db close];
    
    return queryResult;
}

+ (void)createTable {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"course.db"];
    NSLog(@"%@", path);
    FMDatabase *db =[FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        return;
    }
    NSString *sql1 = @"DROP TABLE IF EXISTS course";
    
    if ([db executeStatements:sql1]) {
        NSLog(@"Success");
    }
    
    NSString *sql = @"CREATE TABLE course (id integer primary key,courseName text,courseTime text,courseWeek text,courseTeacher text,courseClassroom text);";
    
    if (![db executeStatements:sql]) {
        NSLog(@"%@", db.lastErrorMessage);
    }
    
    [db close];
    
}

- (BOOL)saveCourse:(Course *)c {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"course.db"];
    
    FMDatabase *db =[FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        return false;
    }
    NSString *sqlString = [NSString stringWithFormat:@"insert into course (id ,courseName ,courseWeek ,courseTeacher ,courseClassroom, courseTime) values (%d,'%@','%@','%@','%@', '%@')", arc4random() % 20000,c.courseName, c.courseWeek, c.courseTeacher, c.courseClassroom, c.courseTime];
    
    if (![db executeStatements:sqlString]) {
        NSLog(@"%@", db.lastErrorMessage);
    }
    
    [db close];
    return true;
}

- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"name:%@ time:%@ week:%@ teacher:%@ classroom:%@", self.courseName, self.courseTime, self.courseWeek, self.courseTeacher, self.courseClassroom];
    return descriptionString;
}

@end
