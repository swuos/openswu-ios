//
//  GradesTableViewCell.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/23.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewCell.h"
#import <Masonry/Masonry.h>


@implementation GradesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.kcmc];
        [self addSubview:self.cj];
        [self addSubview:self.xf];
        CGRect rect = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width / 3 * 2, 40);
        self.kcmc.frame = rect;
        rect.origin.x = rect.origin.x + rect.size.width;
        rect.size.width = 45;
        self.cj.frame = rect;
        rect.origin.x = rect.origin.x + rect.size.width + 20;
        self.xf.frame = rect;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark getters

- (UILabel *)kcmc {
    if (!_kcmc) {
        _kcmc = [[UILabel alloc] init];
    }
    return _kcmc;
}

- (UILabel *)cj {
    if (!_cj) {
        _cj = [[UILabel alloc] init];
    }
    return _cj;
}

- (UILabel *)xf {
    if (!_xf) {
        _xf = [[UILabel alloc] init];
    }
    return _xf;
}

@end
