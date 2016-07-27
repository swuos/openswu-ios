//
//  CourseTableViewCell.h
//  SwuAssistant
//
//  Created by Kric on 3/6/16.
//  Copyright © 2016 OpenSource Association of SWU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface CourseTableViewCell : UITableViewCell

- (void)coufigureWithCourse: (Course *)course;

@end
