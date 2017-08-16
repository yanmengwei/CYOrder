//
//  RestaurantCell.m
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "RestaurantCell.h"
@interface RestaurantCell(){
    RestaurantCellStatus _staus;
    NSString *_title;
}
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong) UIButton *unBtn;
@property (nonatomic,strong)UIButton *staBtn;
@property (nonatomic,strong) UIButton *veryBtn;
@property (nonatomic, nonnull,strong) UIView *line;
@end
@implementation RestaurantCell
- (instancetype)initWithTitle:(NSString *)title defaultStatus:(RestaurantCellStatus)defafultStatus{
    self = [super init];
    if(self){
        _staus = defafultStatus;
        _title = title;
        [self setUpSubview];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-  (void)setUpSubview{
    
    
    __weak UIView *superview = self;

    [superview addSubview:self.titleLabel];
    [superview addSubview:self.unBtn];
    [superview addSubview:self.staBtn];
    [superview addSubview:self.veryBtn];
    [superview addSubview:self.line];
    

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-35);
        make.bottom.equalTo(superview);
        make.height.offset(0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_left);
        make.centerY.equalTo(superview);
    }];
    [self.veryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line.mas_right);
        make.centerY.equalTo(superview);
        make.width.offset(75);
        make.height.offset(25);
    }];
    [self.staBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.veryBtn.mas_left).offset(-10);
        make.centerY.equalTo(superview);
        make.width.offset(52);
        make.height.offset(25);
    }];
    [self.unBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.staBtn.mas_left).offset(-10);
        make.centerY.equalTo(superview);
        make.width.offset(65);
        make.height.offset(25);
    }];

    
}
- (void)didClickBtn:(UIButton *)sender{
    sender.selected = YES;
    if ([sender isEqual:self.unBtn]) {
        self.staBtn.selected = NO;
        self.veryBtn.selected = NO;
    }
    if ([sender isEqual:self.staBtn]) {
        self.unBtn.selected = NO;
        self.veryBtn.selected = NO;
    }
    if ([sender isEqual:self.veryBtn]) {
        self.unBtn.selected = NO;
        self.staBtn.selected = NO;
    }
    
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = CYTextColor;
        _titleLabel.text = _title;
    }
    return _titleLabel;
}
- (UIButton *)unBtn{
    if (_unBtn == nil) {
        _unBtn = [[UIButton alloc]init];
        [_unBtn setBackgroundImage:[UIImage imageNamed:@"unsatisfaction_unselected"] forState:UIControlStateNormal];
        [_unBtn setBackgroundImage:[UIImage imageNamed:@"unsatisfaction_selected"] forState:UIControlStateSelected];
        [_unBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unBtn;
}
- (UIButton *)staBtn{
    if (_staBtn == nil) {
        _staBtn = [[UIButton alloc]init];
        [_staBtn setBackgroundImage:[UIImage imageNamed:@"satisfaction_unselected"] forState:UIControlStateNormal];
        [_staBtn setBackgroundImage:[UIImage imageNamed:@"satisfaction_selected"] forState:UIControlStateSelected];
        [_staBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _staBtn.selected = YES;
    }
    return _staBtn;
}
- (UIButton *)veryBtn{
    if (_veryBtn == nil) {
        _veryBtn = [[UIButton alloc]init];
        [_veryBtn setBackgroundImage:[UIImage imageNamed:@"very_satisfaction_unselected"] forState:UIControlStateNormal];
        [_veryBtn setBackgroundImage:[UIImage imageNamed:@"very_satisfaction_selected"] forState:UIControlStateSelected];
        [_veryBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _veryBtn;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    }
    return _line;
}
@end
