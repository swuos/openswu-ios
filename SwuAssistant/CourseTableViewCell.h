//
//  CourseTableViewCell.h
//  SwuAssistant
//
//  Created by Kric on 3/6/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTeacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseSectionLabel;

//@property (nonatomic, strong) UILabel *courseClassroomLabel;

@end
