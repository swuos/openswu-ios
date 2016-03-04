//
//  SAUser.m
//  SwuAssistant
//
//  Created by Kric on 16/2/3.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "SAUser.h"
#import <FMDB/FMDB.h>

@implementation SAUser

+ (instancetype)sharedInstance {
    static SAUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[SAUser alloc] init];
    });
    return user;
}

+ (BOOL)saveModel {
    [[SAUser sharedInstance] createDataBase];
    return NO;
}

+ (BOOL)readModel {
    return NO;
}

- (FMDatabase *)createDataBase {
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *dbPath = [path stringByAppendingPathComponent:@"abc.db"];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        NSLog(@"error");
//        return nil;
//    } else {
//        NSLog(@"%@", db.databasePath);
//    }
//    FMResultSet *result = [db executeQuery:@"select * from user where name <> '123'"];
//    while ([result next]) {
//        int userid = [result intForColumnIndex:0];
//        NSString *name = [result stringForColumnIndex:1];
//        NSString *password = [result stringForColumnIndex:2];
//        NSLog(@"%d==%@==%@",userid, name, password);
//    }
//    [db executeUpdate:@"update user set name = 'co' where password = '333' and id = 2"];
//    
//    result = [db executeQuery:@"select * from user"];
//    
//    while ([result next]) {
//        int userid = [result intForColumnIndex:0];
//        NSString *name = [result stringForColumnIndex:1];
//        NSString *password = [result stringForColumnIndex:2];
//        NSLog(@"%d==%@==%@",userid, name, password);
//    }
//    [db close];
    return nil;
}

@end
