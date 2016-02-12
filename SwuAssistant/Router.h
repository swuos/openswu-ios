//
//  Router.h
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol updateData <NSObject>

- (void)updateDataWithArray:(NSArray *)dict;

@end


@interface Router : NSObject

@property (nonatomic, strong) NSString *SWUID;

@property (nonatomic, weak) id<updateData> delegate;

+ (Router *)sharedInstance;

- (void)loginWithName:(NSString *)name Password:(NSString *)password CompletionHandler:(void (^)(NSString *))completionBlock;

- (void)getGradesInXN:(NSString *)xn XQ:(NSString *)xq CompletionHandler:(void(^)(NSString *))block;

@end
