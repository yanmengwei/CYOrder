//
//  orderCell.m
//  CYOrder
//
//  Created by ymw on 17/4/5.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "OrderCell.h"
#import "CYMenuModel.h"
@interface OrderCell()
/**
 * 菜名
 */
@property (nonatomic,strong) UILabel *menuLabel;
/**
 *  价格
 */
@property (nonatomic,strong) UILabel *priceLabel;
/**
 *  删除按钮
 */
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *bottomLine;
@property (nonatomic,strong) UILabel *countLabel;

@end
@implementation OrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{
    __weak UIView *superview = self.contentView;
    [superview addSubview:self.bgImageView];
    [superview addSubview:self.menuLabel];
    [superview addSubview:self.priceLabel];
    [superview addSubview:self.deleteBtn];
    [superview addSubview:self.label];
    [superview addSubview:self.bottomLine];
    [superview addSubview:self.countLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.offset(2);
        make.bottom.equalTo(superview.mas_bottom).offset(-2);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(6);
        make.height.width.offset(18);
        make.centerY.mas_equalTo(superview);
    }];
    [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deleteBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(superview);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(superview).offset(-10);
        make.centerY.mas_equalTo(superview);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.countLabel.mas_left).offset(-1);
        make.centerY.mas_equalTo(superview);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(superview);
        make.right.equalTo(self.priceLabel.mas_left).offset(-2);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(superview.mas_bottom);
        make.width.equalTo(superview.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(superview);
    }];

    
}
#pragma mark - responseEvent
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if ([self isSelected]) {
        
        self.menuLabel.textColor = [UIColor whiteColor];
        self.priceLabel.textColor = [UIColor whiteColor];
        self.label.textColor = [UIColor whiteColor];
        self.countLabel.textColor = [UIColor whiteColor];
        self.deleteBtn.hidden = NO;
        self.bgImageView.hidden = NO;
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.deleteBtn.hidden = YES;
        self.bgImageView.hidden = YES;
        self.menuLabel.textColor = CYTextColor;
        self.priceLabel.textColor = CYTextColor;
        self.label.textColor = CYTextColor;
        self.countLabel.textColor = CYTextColor;
    }

}
- (void)didClickDeleteBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCell:didSelectDeleteBtnWithOrderModel:)]) {
        [self.delegate orderCell:self didSelectDeleteBtnWithOrderModel:self.orderModel];
    }
}
- (void)reloadData{
    if (self.orderModel.menuModel.name.length > 5) {
        self.menuLabel.text = [NSString stringWithFormat:@"%@...",[self.orderModel.menuModel.name substringToIndex:5]];
    }else{
        self.menuLabel.text = self.orderModel.menuModel.name;
        
    }
    
    if (_orderModel.count>1) {
        self.countLabel.text = [NSString stringWithFormat:@"/%ld份",(long)self.orderModel.count];
    }else{
        self.countLabel.text = @"/份";
    }
    
    if (self.orderModel.menuModel.discount_price > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"%.f",self.orderModel.menuModel.discount_price];

    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"%.f",self.orderModel.menuModel.price];
    }
}
#pragma mark - init
- (void)setOrderModel:(CYOrderListModel *)orderModel{
    _orderModel = orderModel;
    [self reloadData];
}
- (UILabel *)menuLabel{
    if (_menuLabel == nil) {
        _menuLabel = [[UILabel alloc]init];
        _menuLabel.textAlignment = NSTextAlignmentCenter;
        _menuLabel.textColor = CYTextColor;
        _menuLabel.font = CYDefaultTextFont(15);

    }
    return _menuLabel;
}
- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = CYTextColor;
        
    }
    return  _priceLabel;
}
- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc]init];
//        _deleteBtn.hidden = YES;
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"ordercell_delete"] forState:UIControlStateNormal];
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.layer.cornerRadius = 9.f;
        [_deleteBtn addTarget:self action:@selector(didClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.backgroundColor = [UIColor redColor];
    
    }
    return _deleteBtn;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ordercell_select"]];
        _bgImageView.userInteractionEnabled = YES;
//        _bgImageView.hidden = ye
    }
    return _bgImageView;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = CYDefaultTextFont(12);
        _label.textColor = CYTextColor;
        _label.text = @"¥";
    }
    return _label;
}
- (UIImageView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_cell_split_line"]];
        
    }
    return _bottomLine;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = CYTextColor;
    }
    return _countLabel;
}


@end
