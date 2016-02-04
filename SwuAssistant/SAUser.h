//
//  SAUser.h
//  SwuAssistant
//
//  Created by Kric on 16/2/3.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAUser : NSObject

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *SWUID;


+ (instancetype)sharedInstance;
+ (BOOL)saveModel;
+ (BOOL)readModel;


@end
