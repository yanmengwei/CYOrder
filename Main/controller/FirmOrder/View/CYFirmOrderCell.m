//
//  CYFirmOrderCell.m
//  CYOrder
//
//  Created by ymw on 17/4/24.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYFirmOrderCell.h"
@interface CYFirmOrderCell()
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@end
@implementation CYFirmOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CYFirmOrderCellIdentifier";
    CYFirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CYFirmOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{
    UILabel *classifierLabel = [[UILabel alloc]init];
    classifierLabel.textColor = CYTextColor;
    classifierLabel.font = CYDefaultTextFont(15);
    classifierLabel.text = @"份";
    
    UILabel *symbolLabel = [[UILabel alloc]init];
    symbolLabel.textColor = CYTextColor;
    symbolLabel.font = CYDefaultTextFont(12);
    symbolLabel.text = @"¥";
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_list_line"]];
    
    __weak UIView *superview = self;
    [superview addSubview:self.countLabel];
    [superview addSubview:classifierLabel];
    [superview addSubview:self.nameLabel];
    [superview addSubview:symbolLabel];
    [superview addSubview:self.priceLabel];
    [superview addSubview:line];

    
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.bottom.offset(-14);
    }];
    
    [classifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(5);
        make.bottom.equalTo(self.countLabel.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).offset(85);
        make.bottom.equalTo(classifierLabel.mas_bottom);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(symbolLabel.mas_right).offset(3);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    [symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview.mas_right).offset(-80);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(superview.mas_bottom);
        make.width.equalTo(superview.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(superview);
    }];
}
- (void)setMenuModel:(CYOrderListModel *)menuModel{
    _menuModel = menuModel;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",_menuModel.count];
    self.nameLabel.text = _menuModel.menuModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%.1f",_menuModel.menuModel.price*_menuModel.count];
}
- (void)setPackageModel:(CYPackageModel *)packageModel{
    _packageModel = packageModel;
    self.countLabel.text = @"1";
    self.nameLabel.text = _packageModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%.1f",_packageModel.price];
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.font = CYDefaultTextFont(15);
        _countLabel.textColor = CYTextColor;
    }
    return _countLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = CYDefaultTextFont(15);
        _nameLabel.textColor = CYTextColor;
    }
    return _nameLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = CYDefaultTextFont(15);
        _priceLabel.textColor = CYTextColor;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

@end
