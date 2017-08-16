//
//  CountView.m
//  CYOrder
//
//  Created by ymw on 17/4/25.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CountView.h"
@interface CountView()


@end

@implementation CountView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews{
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = CYTextColor;
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.textColor = CYTextColor;
    firstLabel.font = CYDefaultTextFont(15);
    firstLabel.text = @"总价:";
    
    UILabel *symbol1 = [[UILabel alloc]init];
    symbol1.text = @"¥";
    symbol1.textColor = CYTextColor;
    symbol1.font = CYDefaultTextFont(12);
    
    
    _discountLabel = [[UILabel alloc]init];
    _discountLabel.text = @"优惠价:";
    _discountLabel.textColor = [UIColor colorWithRed:213/255.0 green:32/255.0 blue:0 alpha:1];
    _discountLabel.font = CYDefaultTextFont(15);

    UILabel *symbol2 = [[UILabel alloc]init];
    symbol2.text = @"¥";
    symbol2.textColor = [UIColor colorWithRed:213/255.0 green:32/255.0 blue:0 alpha:1];
    symbol2.font = CYDefaultTextFont(15);
    
    
    
    __weak UIView *superview = self;
    
    [superview addSubview:line];
    [superview addSubview:firstLabel];
    [superview addSubview:symbol1];
    [superview addSubview:self.discountLabel];
    [superview addSubview:symbol2];
    [superview addSubview:self.countLabel];
    [superview addSubview:self.vipCountLabel];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.height.offset(1);
        make.centerY.equalTo(superview);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-5);
        make.bottom.equalTo(line.mas_top).offset(-10);
    }];
    
    [symbol1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.countLabel.mas_centerY);
    }];
    
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(symbol1.mas_left);
        make.centerY.equalTo(symbol1.mas_centerY);
    }];
    
    [self.vipCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-5);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];
    
    [symbol2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipCountLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.vipCountLabel.mas_centerY);
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(symbol2.mas_left);
        make.centerY.equalTo(symbol2.mas_centerY);
    }];
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = CYTextColor;
        _countLabel.font = CYDefaultTextFont(15);
    }
    return _countLabel;
}
- (UILabel *)vipCountLabel{
    if (!_vipCountLabel) {
        _vipCountLabel = [[UILabel alloc]init];
        _vipCountLabel.textColor = [UIColor colorWithRed:213/255.0 green:32/255.0 blue:0 alpha:1];
        _vipCountLabel.font = CYDefaultTextFont(18);
    }
    return _vipCountLabel;
}
@end
