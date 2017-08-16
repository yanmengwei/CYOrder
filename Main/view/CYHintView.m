//
//  CYHintView.m
//  CYOrder
//
//  Created by ymw on 17/4/28.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYHintView.h"
#define TextColor [UIColor colorWithRed:0 green:135/255.0 blue:239/255.0 alpha:1]
@interface CYHintView(){
    UIView *_bgView;
    NSArray *_btnArr;
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@end


@implementation CYHintView

- (instancetype)initWithTitles:(NSString *)title buttonArr:(NSArray *)btnArr{

    self = [super init];
    if (self) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.titleLabel.text = title;
        _btnArr = btnArr;
        [self setUpSubviews];
        
    }
    return self;
}
- (void)setUpSubviews{
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hint"]];
    UILabel *hintLabel = [[UILabel alloc]init];
    hintLabel.textColor = TextColor;
    hintLabel.text = @"提示";
    hintLabel.font = [UIFont systemFontOfSize:18];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = TextColor;
    
    
    __weak UIView *superview = self;
    [superview addSubview:imageview];
    [superview addSubview:hintLabel];
    [superview addSubview:line];
    [superview addSubview:self.titleLabel];
    [superview addSubview:self.sureBtn];
    [superview addSubview:self.cancelBtn];
    
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.top.offset(12);
        make.height.width.offset(26);
    }];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(15);
        make.centerY.equalTo(imageview.mas_centerY);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14);
        make.right.offset(-14);
        make.height.offset(1);
        make.top.equalTo(imageview.mas_bottom).offset(10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(12);
        make.left.offset(18);
        make.right.offset(-18);
    }];
    if (_btnArr.count == 1) {
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-15);
            make.centerX.equalTo(superview.mas_centerX);
            make.height.offset(35);
            make.width.offset(90);
        }];
    }else{
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-15);
            make.centerX.equalTo(superview.mas_centerX).multipliedBy(0.5);
            make.height.offset(35);
            make.width.offset(90);
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-15);
            make.centerX.equalTo(superview.mas_centerX).multipliedBy(1.5);
            make.height.offset(35);
            make.width.offset(90);
        }];
    }

    
}
- (void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication]keyWindow];
    [keywindow addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(keywindow);
    }];
    [_bgView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(325);
        make.height.offset(190);
        make.center.equalTo(_bgView);
    }];
    
}
- (void)didClickBtn:(UIButton *)sender{
    [self hide];
    if ([sender isEqual:self.sureBtn]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hintView:didSelcetBtnAtIndex:)]) {
            [self.delegate hintView:self didSelcetBtnAtIndex:0];
        }
    }
    if ([sender isEqual:self.cancelBtn]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hintView:didSelcetBtnAtIndex:)]) {
            [self.delegate hintView:self didSelcetBtnAtIndex:1];
        }
    }
}
- (void)hide{
    [_bgView removeFromSuperview];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        _sureBtn.backgroundColor = TextColor;
        _sureBtn.titleLabel.textColor = [UIColor whiteColor];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.layer.cornerRadius = 5.0;
        [_sureBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.backgroundColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.textColor = [UIColor whiteColor];
        _cancelBtn.layer.cornerRadius = 5.0;
        [_cancelBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _cancelBtn;
}
@end
