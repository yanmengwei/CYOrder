//
//  CYCommentView.m
//  CYOrder
//
//  Created by ymw on 17/6/12.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYCommentView.h"
@interface CYCommentView(){

}
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *caiBtn;
@end

@implementation CYCommentView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubview];
    }
    return self;
}
- (void)setUpSubview{
    __weak UIView *superview = self;
    [superview addSubview:self.zanBtn];
    [superview addSubview:self.caiBtn];
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(superview);
        make.width.equalTo(superview).multipliedBy(0.5).offset(-10);
    }];
    [self.caiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(superview);
        make.width.equalTo(self.zanBtn.mas_width);
    }];
    
    
}
- (void)didClickBtn:(UIButton *)sender{
    if ([sender isEqual:self.zanBtn]) {
        //如果点击的是赞
        self.zanBtn.selected = YES;
        self.caiBtn.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeCommentStatus:)]) {
            [self.delegate didChangeCommentStatus:EvaluateStatusZan];
        }
        
    }else{
        //如果点击的是踩
        self.caiBtn.selected = YES;
        self.zanBtn.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeCommentStatus:)]) {
            [self.delegate didChangeCommentStatus:EvaluateStatusCai];
        }
    }
}
- (UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [[UIButton alloc]init];
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"zan_unselected"] forState:UIControlStateNormal];
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"zan_selected"] forState:UIControlStateSelected];
        [_zanBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanBtn;
}
- (UIButton *)caiBtn{
    if (!_caiBtn) {
        _caiBtn = [[UIButton alloc]init];
        [_caiBtn setBackgroundImage:[UIImage imageNamed:@"cai_unselected"] forState:UIControlStateNormal];
        [_caiBtn setBackgroundImage:[UIImage imageNamed:@"cai_seleceted"] forState:UIControlStateSelected];
        [_caiBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _caiBtn;
}
- (void)setDefaultType:(EvaluateStatus)defaultType{
    _defaultType = defaultType;
    switch (_defaultType) {
        case EvaluateStatusCai:
            self.caiBtn.selected = YES;
            self.zanBtn.selected = NO;
            break;
        case EvaluateStatusZan:
            self.zanBtn.selected = YES;
            self.caiBtn.selected = NO;
            
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
