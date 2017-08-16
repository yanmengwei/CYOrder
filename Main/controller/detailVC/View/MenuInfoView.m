//
//  MenuInfoView.m
//  CYOrder
//
//  Created by ymw on 17/4/19.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "MenuInfoView.h"
@interface MenuInfoView()
/**
 *  产品名称
 */
@property (nonatomic,strong) UILabel *nameLabel;


@property (nonatomic,strong) UILabel *menuNameLabel;

/**
 *  产品简介
 */
@property (nonatomic,strong) UILabel *briefLabel;

/**
 *  背景图
 */
@property (nonatomic,strong) UIView *detailBgView;

@end
@implementation MenuInfoView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{
    
    __weak UIView *superview = self;
    [superview addSubview:self.detailBgView];
    [superview addSubview:self.nameLabel];
    [superview addSubview:self.menuNameLabel];
    [superview addSubview:self.briefLabel];
    
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(24);
        make.right.equalTo(superview).offset(-24);
        make.bottom.equalTo(superview).offset(-12);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.briefLabel.mas_top).offset(-12);
        make.left.equalTo(self.briefLabel.mas_left);
    }];
    
    [self.menuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.bottom.equalTo(self.nameLabel.mas_bottom).offset(-3);
//        make.right.equalTo(superview).offset(-24);
    }];
    
    [self.detailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superview);
        make.top.equalTo(self.nameLabel.mas_top).offset(-12);
        make.left.right.equalTo(superview);
    }];

    
}
- (void)didClickCloseBtn:(UIButton *)sender{
    [self removeFromSuperview];
}
- (void)setMenuModel:(CYMenuModel *)menuModel{
    _menuModel = menuModel;
    self.nameLabel.attributedText = [self attStrWithStr:@"产品名称:"];
    self.menuNameLabel.attributedText = [self attStrWithStr:_menuModel.name];

    
    NSString *str = [NSString stringWithFormat:@"产品来源：%@",_menuModel.brief];
    self.briefLabel.attributedText = [self attStrWithStr:str];
    
}
- (NSAttributedString *)attStrWithStr:(NSString *)str{

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:6];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return attributedString;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"产品名称";
    }
    return _nameLabel;
}
- (UILabel *)briefLabel{
    if (!_briefLabel) {
        _briefLabel = [[UILabel alloc]init];
        _briefLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _briefLabel.font =  [UIFont systemFontOfSize:15];
        _briefLabel.numberOfLines = 0;
        _briefLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _briefLabel;
}
- (UILabel *)menuNameLabel
{
    if (_menuNameLabel == nil) {
        _menuNameLabel = [[UILabel alloc]init];
        _menuNameLabel.textColor = [UIColor blackColor];
        _menuNameLabel.font = CYDefaultTextFont(18);
        _menuNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _menuNameLabel;
}
- (UIView *)detailBgView{
    if (!_detailBgView) {
        _detailBgView = [[UIView alloc]init];
        _detailBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    }
    return _detailBgView;
}
@end
