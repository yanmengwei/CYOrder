//
//  CYPayCell.m
//  CYOrder
//
//  Created by ymw on 17/4/27.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYPayCell.h"
#import "CYCommentView.h"
@interface CYPayCell()<CYCommentViewDelegate>
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *symbolLabel;
@property (nonatomic,strong) CYCommentView *commentView;

@end
@implementation CYPayCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CYPayCell";
    CYPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CYPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
  
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firm_order_list_line"]];
    
    __weak UIView *superview = self.contentView;
    [superview addSubview:self.countLabel];
    [superview addSubview:classifierLabel];
    [superview addSubview:self.nameLabel];
    [superview addSubview:self.symbolLabel];
    [superview addSubview:self.priceLabel];
    [superview addSubview:line];
    [superview addSubview:self.commentView];
    
    
    
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
    

    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview.mas_right).offset(-80);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.symbolLabel.mas_right).offset(3);
        make.centerY.equalTo(self.symbolLabel.mas_centerY);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.centerY.equalTo(superview.mas_bottom);
        make.width.equalTo(superview.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(superview);
    }];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.width.offset(110);
        make.right.equalTo(superview).offset(-20);
        make.height.offset(30);
    }];
 
}

//实时更新评级值

#pragma mark - delegate
#pragma mark - init
- (void)setListModel:(CYOrderListModel *)listModel{
    _listModel = listModel;
    if (listModel.menu_id) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld",listModel.count];
        self.nameLabel.text = _listModel.menuModel.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%.1f",_listModel.menuModel.price*_listModel.count];
    }else if (listModel.package_id){
        self.countLabel.text = [NSString stringWithFormat:@"%ld",listModel.count];
        self.nameLabel.text = _listModel.packageModel.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%.1f",_listModel.packageModel.price*_listModel.count];
    }

    if (_listModel.is_evaluation) {
        //表示已经评价过
        self.commentView.defaultType = _listModel.evaluate;
        self.commentView.hidden = NO;
        [self.symbolLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentView.mas_left).offset(-60);
            make.bottom.equalTo(self.nameLabel.mas_bottom);
        }];
    }else{
        self.commentView.hidden = YES;
        [self.symbolLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-80);
            make.bottom.equalTo(self.nameLabel.mas_bottom);
        }];
    }

}
- (void)setCellType:(CYPayCellType )cellType{
    _cellType = cellType;
    //如果没有评价过
    if(_cellType == CYPayCellTypeCommentComplete){
        self.commentView.userInteractionEnabled = NO;
    }else{
        self.commentView.userInteractionEnabled = YES;
    }
 
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
- (CYCommentView *)commentView{
    if (!_commentView) {
        _commentView = [[CYCommentView alloc]init];
        _commentView.delegate = self;
    }
    return _commentView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)symbolLabel{
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc]init];
        _symbolLabel.textColor = CYTextColor;
        _symbolLabel.font = CYDefaultTextFont(12);
        _symbolLabel.text = @"¥";
    }
    return _symbolLabel;
}

@end
