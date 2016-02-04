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
    
    return NO;
}

+ (BOOL)readModel {
    return NO;
}

- (FMDatabase *)createDataBase {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
    if (![db open]) {
        return nil;
    } else {
        NSLog(@"%@", db.databasePath);
    }
    return nil;
}

@end
