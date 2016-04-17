//
//  CourseTableViewCell.m
//  SwuAssistant
//
//  Created by Kric on 3/7/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "CourseTableViewCell.h"

@implementation CourseTableViewCell

- (void)awakeFromNib {
    self.courseNameLabel.text = @"";
    self.courseTeacherLabel.text = @"";
    self.courseWeekLabel.text = @"";
    self.courseSectionLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
