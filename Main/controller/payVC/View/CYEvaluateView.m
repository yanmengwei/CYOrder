//
//  CYEvaluateView.m
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYEvaluateView.h"
#import "CYMenuEvaluateView.h"
#import "EvaluateRestaurantView.h"
#import "CYRestuarantEvaluateModel.h"
@interface CYEvaluateView()<UITextViewDelegate,CYMenuEvaluateViewDelegate,EvaluateRestaurantViewDelegate>{
    UIImageView *_selfDefineBg;
    CYRestuarantEvaluateModel *_resModel;
    NSMutableArray *_evaMenuArr;
}
@property (nonatomic,strong) CYMenuEvaluateView *menuView;
@property (nonatomic,strong) EvaluateRestaurantView *restaurantView;
@property (nonatomic,strong) UITextView *evaluteTV;
@property (nonatomic,strong) UILabel *tfPlaceholderLabel;
@property (nonatomic,strong) UIButton *commitBtn;

@end
@implementation CYEvaluateView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{
    __weak UIView *superview = self;
    [superview addSubview:self.menuView];
    [superview addSubview:self.restaurantView];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superview);
        make.height.offset(205);
    }];
    [self.restaurantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.menuView);
        make.top.equalTo(self.menuView.mas_bottom).offset(7.5);
        make.height.offset(165);
    }];
    
    //自定义评价cell
    _selfDefineBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_order_bg"]];
    _selfDefineBg.userInteractionEnabled = YES;
    [superview addSubview:_selfDefineBg];
    
    [_selfDefineBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superview);
        make.top.equalTo(self.restaurantView.mas_bottom).offset(7.5);
    }];
    
    [_selfDefineBg addSubview:self.evaluteTV];
    [_selfDefineBg addSubview:self.commitBtn];
    [self.evaluteTV addSubview:self.tfPlaceholderLabel];
    [self.evaluteTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32);
        make.right.offset(-32);
        make.top.offset(10);
        make.bottom.equalTo(self.commitBtn.mas_top).offset(-15);
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_selfDefineBg);
        make.width.offset(125);
        make.height.offset(45);
        make.bottom.equalTo(_selfDefineBg.mas_bottom).offset(-15);
    }];
    [self.tfPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
    }];
    
    
    
}
- (void)didClickCommitBtn:(UIButton *)sender{
    //点击评价
    _resModel.evaluation = self.evaluteTV.text;
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickSubmitCommentBtnWithOrderModelArr:andRestuarantModel:)]) {
        
        [self.delegate didClickSubmitCommentBtnWithOrderModelArr:_evaMenuArr andRestuarantModel:_resModel];
    }
}
#pragma mark - 评价部分代理
#pragma mark 餐厅评价
- (void)didChangeResEvaWithModel:(CYRestuarantEvaluateModel *)resModel{
    _resModel = resModel;
}
#pragma mark 菜品评价
- (void)didChangeMenuEvaStatusWithOrderListArr:(NSArray *)arr{
    _evaMenuArr = [NSMutableArray arrayWithArray:arr];
}
#pragma mark - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.tfPlaceholderLabel.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        [_selfDefineBg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(self.menuView).offset(20);
            make.top.offset(7.5);
        }];
        [self layoutIfNeeded];
        self.menuView.hidden = YES;
        self.restaurantView.hidden = YES;
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.tfPlaceholderLabel.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
        [_selfDefineBg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.restaurantView.mas_bottom).offset(7.5);
        }];
        [self layoutIfNeeded];
        self.menuView.hidden = NO;
        self.restaurantView.hidden = NO;
    }];

}
- (void)setOrderModelArr:(NSArray *)orderModelArr{
    _orderModelArr = orderModelArr;
    NSMutableArray *arr = [NSMutableArray array];
    _evaMenuArr = [NSMutableArray array];
    for (CYOrderModel *orderModel in _orderModelArr) {
        [arr addObjectsFromArray:orderModel.orderListModelArr];
        for (CYOrderListModel *lsModel in orderModel.orderListModelArr) {
            lsModel.evaluate = EvaluateStatusZan;
            [_evaMenuArr addObject:lsModel];
        }
        [arr addObjectsFromArray:orderModel.packageArr];
        for (CYOrderListModel *paModel in orderModel.packageArr) {
            paModel.evaluate = EvaluateStatusZan;
            [_evaMenuArr addObject:paModel];
        }
    }
    self.menuView.orderListArr = arr;
}
/*
- (void)setOrderModel:(CYOrderModel *)orderModel{
    _orderModel = orderModel;
    self.menuView.orderListArr = [NSMutableArray arrayWithArray:_orderModel.orderListModelArr];
}
*/
- (CYMenuEvaluateView *)menuView{
    if (!_menuView) {
        _menuView = [[CYMenuEvaluateView alloc]init];
    }
    return _menuView;
}

- (EvaluateRestaurantView *)restaurantView{
    if (!_restaurantView) {
        _restaurantView = [[EvaluateRestaurantView alloc]init];
    }
    return _restaurantView;
}
- (UITextView *)evaluteTV{
    if (!_evaluteTV) {
        _evaluteTV = [[UITextView alloc]init];
        _evaluteTV.delegate = self;
        _evaluteTV.backgroundColor = [UIColor whiteColor];
        _evaluteTV.layer.masksToBounds = YES;
        _evaluteTV.layer.borderWidth = 1.0;
        _evaluteTV.layer.borderColor = [UIColor colorWithRed:221/255. green:221/255. blue:221/255. alpha:1].CGColor;
        _evaluteTV.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _evaluteTV.font = [UIFont systemFontOfSize:17];
    }
    
    return _evaluteTV;
}
- (UILabel *)tfPlaceholderLabel{
    if (!_tfPlaceholderLabel) {
        _tfPlaceholderLabel = [[UILabel alloc]init];
        _tfPlaceholderLabel.text = @"点此输入自定义评价";
        _tfPlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _tfPlaceholderLabel.textColor = [UIColor colorWithRed:221/255. green:221/255. blue:221/255. alpha:1];
    }
    return _tfPlaceholderLabel;
}
- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc]init];
        [_commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_commit_comment"] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(didClickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

@end
