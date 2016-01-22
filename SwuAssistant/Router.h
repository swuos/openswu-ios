//
//  Router.h
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol refresh <NSObject>

- (void)refreshWithDict:(NSArray *)dict;

@end


@interface Router : NSObject

@property (nonatomic, weak) id<refresh> delegate;

+ (Router *)sharedInstance;

- (void)loginWithName:(NSString *)name AndPassword:(NSString *)password AndCompletionHandler:(void (^)(NSString *))blockName;

- (void)getGrades;

@end
