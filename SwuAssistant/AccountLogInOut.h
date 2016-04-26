//
//  AccountLogInOut.h
//  SwuAssistant
//
//  Created by Kric on 4/26/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionblock)(NSString *);

@interface AccountLogInOut : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userpass;

- (instancetype)init;

- (instancetype)initWithUsername:(NSString *)username Userpass:(NSString *)userpass;

- (void)logOutWithCompletionBlock:(completionblock)ComBlock FailureBlock:(completionblock)FailureBlock;

- (void)logInWithCompletionBlock:(completionblock)ComBlock FailureBlock:(completionblock)FailureBlock;


@end
