//
//  EvaluateRestaurantView.m
//  CYOrder
//
//  Created by ymw on 17/6/14.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "EvaluateRestaurantView.h"
#import "RestaurantCell.h"
#import "CYRestuarantEvaluateModel.h"
@interface EvaluateRestaurantView()<RestaurantCellDelegate>{
    CYRestuarantEvaluateModel *_model;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) RestaurantCell *environmentCell;
@property (nonatomic,strong) RestaurantCell *flavorCell;
@property (nonatomic,strong) RestaurantCell *attitudeCell;

@end
@implementation EvaluateRestaurantView

-(instancetype)init{
    if (self = [super init]) {
        _model = [[CYRestuarantEvaluateModel alloc]init];
        _model.flavor = RestaurantCellStatusSta;
        _model.attitude = RestaurantCellStatusSta;
        _model.environment = RestaurantCellStatusSta;
        [self setUpSubviews];
    }
    return self;
}
- (void)setUpSubviews{

    UIImageView *bgImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_order_bg"]];
    bgImageV.userInteractionEnabled = YES;
    [self addSubview:bgImageV];
    
    __weak UIView *superview = bgImageV;
    [superview addSubview:self.titleLabel];
    [superview addSubview:self.environmentCell];
    [superview addSubview:self.flavorCell];
    [superview addSubview:self.attitudeCell];
    
    
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(30);
        make.height.offset(30);
    }];
    
    [self.environmentCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.offset(40);
    }];
    [self.attitudeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(self.environmentCell.mas_bottom);
        make.height.offset(40);
    }];
    [self.flavorCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(self.attitudeCell.mas_bottom);
        make.height.offset(40);
    }];
}
- (void)restaurantCell:(RestaurantCell *)restaurantCell statusDidChange:(RestaurantCellStatus)status{
    if ([restaurantCell isEqual:self.environmentCell]) {
        _model.environment = status;
    }
    if ([restaurantCell isEqual:self.attitudeCell]) {
        _model.attitude = status;
    }
    if ([restaurantCell isEqual:self.flavorCell]) {
        _model.flavor = status;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeResEvaWithModel:)]) {
        [self.delegate didChangeResEvaWithModel:_model];
    }
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"商家评价";
        _titleLabel.font = CYDefaultTextFont(16);
        _titleLabel.textColor = CYTextColor;
    }
    return _titleLabel;
}
- (RestaurantCell *)environmentCell{
    if (!_environmentCell) {
        _environmentCell = [[RestaurantCell alloc]initWithTitle:@"餐厅环境" defaultStatus:RestaurantCellStatusSta];
        _environmentCell.delegate = self;
    }
    return _environmentCell;
}
- (RestaurantCell *)attitudeCell{
    if (!_attitudeCell) {
        _attitudeCell = [[RestaurantCell alloc]initWithTitle:@"服务态度" defaultStatus:RestaurantCellStatusSta];
        _attitudeCell.delegate = self;
    }
    return _attitudeCell;
}

- (RestaurantCell *)flavorCell{
    if (!_flavorCell) {
        _flavorCell = [[RestaurantCell alloc]initWithTitle:@"菜品口味" defaultStatus:RestaurantCellStatusSta];
        _flavorCell.delegate = self;
    }
    return _flavorCell;
}

@end
