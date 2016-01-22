//
//  GradesTableViewHeaderView.m
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/22.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewHeaderView.h"
@interface GradesTableViewHeaderView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerViewOne;
@property (nonatomic, strong) UIButton *queryButton;

@end

@implementation GradesTableViewHeaderView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 200);
        [self addSubview:self.pickerViewOne];
        [self addSubview:self.queryButton];
    }
    return self;
}

- (UIPickerView *)pickerViewOne {
    if (!_pickerViewOne) {
        _pickerViewOne = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 180)];
        _pickerViewOne.delegate = self;
        _pickerViewOne.dataSource = self;
    }
    return _pickerViewOne;
}

- (UIButton *)queryButton {
    if (!_queryButton) {
        _queryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _queryButton.frame = CGRectMake(0, 180, [[UIScreen mainScreen] bounds].size.width, 20);
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton addTarget:self action:@selector(queryGrades) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}

- (void)queryGrades {
    NSLog(@"fucking");
}

#pragma mark picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width/2, 100);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"123";
}


@end
