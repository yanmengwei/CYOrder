//
//  HadOrderCell.m
//  CYOrder
//
//  Created by ymw on 17/4/26.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "HadOrderCell.h"
@interface HadOrderCell()
/**
 * 菜名
 */
@property (nonatomic,strong) UILabel *menuLabel;
/**
 *  价格
 */
@property (nonatomic,strong) UILabel *priceLabel;


@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *bottomLine;
@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,strong) UIImageView *imageview;

@end
@implementation HadOrderCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HadOrderCellIdentifier";
    HadOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HadOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [superview addSubview:self.menuLabel];
    [superview addSubview:self.priceLabel];
    [superview addSubview:self.label];
    [superview addSubview:self.bottomLine];
    [superview addSubview:self.countLabel];
    [superview addSubview:self.imageview];
    
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(6);
        make.width.height.offset(15);
        make.centerY.equalTo(superview);
    }];

    [self.menuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(29);
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
- (void)setOrderListModel:(CYOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    CYMenuModel *menuModel = [[DataBase shareDataBase]getMenuWithMenuId:_orderListModel.menu_id];
    if (menuModel.name.length > 5) {
        self.menuLabel.text = [NSString stringWithFormat:@"%@...",[menuModel.name substringToIndex:5]];
    }else{
        self.menuLabel.text = menuModel.name;
        
    }
    
    if (orderListModel.count>1) {
        self.countLabel.text = [NSString stringWithFormat:@"/%ld份",(long)orderListModel.count];
    }else{
        self.countLabel.text = @"/份";
    }
    
    if (menuModel.discount_price > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"%.f",menuModel.discount_price];
        
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"%.f",menuModel.price];
    }
}
/**
 *          self.priceLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
 self.menuLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
 self.label.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
 self.countLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
 *
 *  @return <#return value description#>
 */
- (UILabel *)menuLabel{
    if (_menuLabel == nil) {
        _menuLabel = [[UILabel alloc]init];
        _menuLabel.textAlignment = NSTextAlignmentCenter;
        _menuLabel.font = CYDefaultTextFont(15);
        _menuLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
        
    }
    return _menuLabel;
}
- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
        
    }
    return  _priceLabel;
}


- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = CYDefaultTextFont(12);
        _label.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
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
        _countLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
    }
    return _countLabel;
}
- (UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"making"]];
        _imageview.backgroundColor = [UIColor redColor];
    }
    return _imageview;
}
- (void)setShowLine:(BOOL)showLine{
    _showLine = showLine;
    self.bottomLine.hidden = _showLine;
}
- (void)setShowAnti:(BOOL)showAnti{
    _showAnti = showAnti;
    self.imageview.hidden = _showAnti;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    /*
     menuLabel;
    
    @property (nonatomic,strong) UILabel *priceLabel;
    
    
    @property (nonatomic,strong) UILabel *label;
    @property (nonatomic,strong) UIImageView *bottomLine;
    @property (nonatomic,strong) UILabel *countLabel;
     */
    self.label.textColor = _textColor;
    self.priceLabel.textColor = _textColor;
    self.countLabel.textColor = _textColor;
    self.menuLabel.textColor = _textColor;
}
@end
