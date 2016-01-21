//
//  Router.h
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Router : NSObject

+ (Router *)sharedInstance;

- (void)loginWithName:(NSString *)name AndPassword:(NSString *)password AndCompletionHandler:(void (^)(NSString *))blockName;

@end
