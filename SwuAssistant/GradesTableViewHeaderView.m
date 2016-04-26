//
//  GradesTableViewHeaderView.m
//  SwuAssistant
//
//  Created by Kric on 16/1/22.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import "GradesTableViewHeaderView.h"
#import "Router.h"

@interface GradesTableViewHeaderView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerViewOne;
@property (nonatomic, strong) NSMutableArray *arry;
@property (nonatomic, strong) UIButton *queryButton;

@end

@implementation GradesTableViewHeaderView

# pragma mark public method

- (void)setTarget:(id)object Action:(SEL)sel ContorlEvents:(UIControlEvents)event {
    [self.queryButton addTarget:object action:sel forControlEvents:event];
}

- (NSArray *)currentSelection {

    NSInteger sem  = [self.pickerViewOne selectedRowInComponent:1];
    NSInteger year = [self.pickerViewOne selectedRowInComponent:0];
    
    return @[
             [self.arry[year] substringWithRange:NSMakeRange(0,4)],
             [NSString stringWithFormat:@"%ld", sem+1]
            ];
}

# pragma mark help method

- (instancetype)init {
    self = [super init];
    if (self) {
        NSRange range = NSMakeRange(2,4);
        
        NSString *year = [[[Router sharedInstance] SWUID] substringWithRange:range];
        self.arry = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            [self.arry addObject:[NSString stringWithFormat:@"%d~%d",[year intValue]+i,[year intValue]+1+i]];
        }
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
    }
    return _queryButton;
}

#pragma mark picker view data source and delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width/2, 100);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.arry[row];
    } else {
        return [NSString stringWithFormat:@"%ld", row + 1];
    }
}


@end
