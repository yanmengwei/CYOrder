//
//  CYPayMethodCell.m
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPayMethodCell.h"
#import "CYPayMethodModel.h"
@interface CYPayMethodCell()
@property (nonatomic,strong) UILabel *payLabel;
@property (nonatomic,strong) UIImageView *payImageView;
@end
@implementation CYPayMethodCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CYPayMethodCell";
    CYPayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CYPayMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    if (selected) {
        [self.selectImage setImage:[UIImage imageNamed:@"pay_select"]];
    }else{
        [self.selectImage setImage:[UIImage imageNamed:@"pay_no_select"]];
    }
}
- (void)setUpSubviews{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor grayColor];
    __weak UIView *superview = self.contentView;
    [superview addSubview:line];
    [superview addSubview:self.selectImage];
    [superview addSubview:self.payImageView];
    [superview addSubview:self.payLabel];
    
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(superview);
        make.height.offset(1);
    }];
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(45);
        make.width.height.offset(18);
        make.centerY.equalTo(superview);
    }];
    [self.payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImage.mas_right).offset(12);
        make.width.height.offset(45);
        make.centerY.equalTo(superview);
    }];
    [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payImageView.mas_right).offset(15);
        make.centerY.equalTo(superview);
    }];
    
}
- (void)setModel:(CYPayMethodModel *)model{
    _model = model;
    self.payLabel.text = _model.name;
    [self.payImageView setImage:[UIImage imageNamed:_model.imageName]];
}
- (UILabel *)payLabel{
    if (!_payLabel) {
        _payLabel = [[UILabel alloc]init];
        _payLabel.textColor = [UIColor blackColor];
        _payLabel.font = [UIFont systemFontOfSize:18];
    }
    return _payLabel;
}
- (UIImageView *)payImageView{
    if (!_payImageView) {
        _payImageView = [[UIImageView alloc]init];
    }
    return _payImageView;
}
- (UIImageView *)selectImage{
    if (!_selectImage) {
        _selectImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_no_select"]];
    }
    return _selectImage;
}
@end
