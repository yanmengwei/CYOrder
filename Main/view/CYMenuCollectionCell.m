//
//  menuCollectionCell.m
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYMenuCollectionCell.h"
#import "CYMenuModel.h"
#import "CYDailySpecialModel.h"
@interface CYMenuCollectionCell()
@property (nonatomic,strong) UIImageView *menuImageView;
@property (nonatomic,strong) UILabel *menuNameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *detailBtn;

@property (nonatomic,strong) UIImageView *discoutImageView;
@property (nonatomic,strong) UIImageView *goodImageView;


@end
@implementation CYMenuCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    __weak UIView *superview = self.contentView;
    
    [self addSubview:self.discoutImageView];
    [self.discoutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(self).offset(-6);
        make.width.offset(50);
        make.height.offset(44);
    }];
    [superview addSubview:self.menuNameLabel];
    [superview addSubview:self.priceLabel];
    [superview addSubview:self.menuImageView];
    [superview addSubview:self.detailBtn];
    [superview addSubview:self.goodImageView];
    
    [self.menuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.bottom.offset(-10);

    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(-10);
    }];
    
   [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.offset(12);
       make.left.equalTo(self.menuNameLabel.mas_left);
       make.right.equalTo(self.priceLabel.mas_right);
       make.bottom.equalTo(self.priceLabel.mas_bottom).offset(-30);
   }];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(superview);
        make.width.offset(66);
        make.height.offset(62);
    }];
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.menuImageView);
        make.width.offset(50);
        make.height.offset(60);
    }];
}
#pragma mark event 
- (void)didClickDeleteBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didClickDetailBtnWithMenuModel:)]) {
        [self.delegate cell:self didClickDetailBtnWithMenuModel:self.model];
    }
}
#pragma mark - init
- (void)setModel:(CYMenuModel *)model{
    _model = model;

    self.menuNameLabel.text = _model.name;
    [self.menuImageView sd_setImageWithURL:[NSURL URLWithString:_model.img_address] placeholderImage:[UIImage imageNamed:@"default_pic"]];
//    [self.menuImageView setImage:[UIImage imageNamed:_model.img_address]];
    NSMutableAttributedString *attrStr;
    if (_model.is_special) {
        self.discoutImageView.hidden = NO;
        attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %.2f",_model.discount_price]];
    }else{
        self.discoutImageView.hidden = YES;
        attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %.2f",_model.price]];
    }
    if (_model.is_Eva) {
        self.goodImageView.hidden = NO;
    }else{
        self.goodImageView.hidden = YES;
    }
 
    [attrStr addAttribute:NSFontAttributeName value:CYDefaultTextFont(15) range:NSMakeRange(1,attrStr.length - 1)];
    [attrStr addAttribute:NSFontAttributeName value:CYDefaultTextFont(12) range:NSMakeRange(0,1)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:CYTextColor range:NSMakeRange(0,attrStr.length)];
    self.priceLabel.attributedText = attrStr;
}
- (void)setDailyModel:(CYDailySpecialModel *)dailyModel{
    _dailyModel = dailyModel;
    self.model = _dailyModel.menuModel;
}
- (UIImageView*)menuImageView{
    if (_menuImageView == nil) {
        _menuImageView = [[UIImageView alloc]init];
//        _menuImageView.contentMode = UIViewContentModeScaleAspectFit;
        _menuImageView.layer.masksToBounds = YES;
        _menuImageView.layer.borderColor = CYBrownBorderColor.CGColor;
        _menuImageView.layer.borderWidth = 1.5f;
    }
    return _menuImageView;
}
- (UILabel *)menuNameLabel{
    if (_menuNameLabel == nil) {
        _menuNameLabel = [[UILabel alloc]init];
        _menuNameLabel.font = CYDefaultTextFont(15);
        _menuNameLabel.textColor = CYTextColor;
    }
    return _menuNameLabel;
}
- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = CYDefaultTextFont(12);
        _priceLabel.textColor = CYTextColor;
    }
    return _priceLabel;
}
- (UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc]init];
        [_detailBtn setBackgroundImage:[UIImage imageNamed:@"detail_btn"] forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(didClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
}
- (UIImageView *)discoutImageView{
    if (!_discoutImageView) {
        _discoutImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"discount"]];
    }
    return _discoutImageView;
}
- (UIImageView *)goodImageView{
    if (!_goodImageView) {
        _goodImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_zan"]];
        _goodImageView.contentMode = UIViewContentModeCenter;
    }
    return _goodImageView;
}
@end
