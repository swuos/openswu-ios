//
//  GradesTableViewCell.m
//  SwuAssistant
//
//  Created by Kric on 16/1/23.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewCell.h"

@implementation GradesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.courseName];
        [self addSubview:self.courseGrade];
        [self addSubview:self.coursePoint];
        CGRect rect = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width / 3 * 2, 40);
        self.courseName.frame = rect;
        rect.origin.x = rect.origin.x + rect.size.width;
        rect.size.width = 45;
        self.courseGrade.frame = rect;
        rect.origin.x = rect.origin.x + rect.size.width + 20;
        self.coursePoint.frame = rect;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark getters

- (UILabel *)courseName {
    if (!_courseName) {
        _courseName = [[UILabel alloc] init];
    }
    return _courseName;
}

- (UILabel *)courseGrade {
    if (!_courseGrade) {
        _courseGrade = [[UILabel alloc] init];
    }
    return _courseGrade;
}

- (UILabel *)coursePoint {
    if (!_coursePoint) {
        _coursePoint = [[UILabel alloc] init];
    }
    return _coursePoint;
}

@end
