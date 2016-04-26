//
//  GradesTableViewHeaderView.h
//  SwuAssistant
//
//  Created by Kric on 16/1/22.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradesTableViewHeaderView : UIView

- (void)setTarget:(id)object Action:(SEL)sel ContorlEvents:(UIControlEvents)event;
- (NSArray *)currentSelection;

@end
