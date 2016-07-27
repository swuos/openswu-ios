//
//  CourseTableViewCell.m
//  SwuAssistant
//
//  Created by Kric on 3/7/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "Course.h"

@interface CourseTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTeacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseSectionLabel;

@end

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

- (void)coufigureWithCourse: (Course *)course {
    self.courseNameLabel.text    = course.courseName;
    self.courseTeacherLabel.text = course.courseClassroom;
    self.courseWeekLabel.text    = [course.courseWeekDay stringByAppendingString:course.courseTeacher];
    self.courseSectionLabel.text = [course.courseWeekNumber stringByAppendingString: course.courseTime];
}

@end
