//
//  CYDetailViewController.m
//  CYOrder
//
//  Created by ymw on 17/4/19.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "CYDetailViewController.h"
#import "MenuInfoView.h"
@interface CYDetailViewController ()

@property (nonatomic,strong) UILabel *naviTitleLabel;
@property (nonatomic,strong)UIImageView *detailBgView;
@property (nonatomic,strong) UIImageView *detailImgView;
@property (nonatomic,strong) MenuInfoView *infoView;
@end

@implementation CYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self setUpSubviews];
}
- (void)setUpSubviews{
    __weak UIView *superview = self.view;
    [superview addSubview:self.detailBgView];
    [superview addSubview:self.naviTitleLabel];
    [self.detailBgView addSubview:self.detailImgView];
    [self.detailImgView addSubview:self.infoView];

    [self.naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topBgImgView.mas_bottom).offset(-10);
        make.centerX.equalTo(superview);
    }];
    [self.detailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgImgView.mas_bottom).offset(10);
        make.bottom.equalTo(superview).offset(-10);
        make.left.equalTo(superview).offset(33);
        make.right.equalTo(superview).offset(-33);

    }];

    [self.detailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.detailBgView).offset(10);
        make.bottom.right.equalTo(self.detailBgView).offset(-10);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.detailImgView);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMenuModel:(CYMenuModel *)menuModel{
    _menuModel = menuModel;
    [self.detailImgView sd_setImageWithURL:[NSURL URLWithString:_menuModel.img_address]placeholderImage:[UIImage imageNamed:@"default_pic"]] ;
}
- (UIImageView *)detailBgView{
    if (!_detailBgView) {
        _detailBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_image_bg"]];
        
        
        UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_ray_top"]];
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_ray_left"]];
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_ray_right"]];
        
        [_detailBgView addSubview:topImageView];
        [_detailBgView addSubview:leftImageView];
        [_detailBgView addSubview:rightImageView];
        
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_detailBgView);
            make.height.offset(30);
            make.centerY.equalTo(_detailBgView.mas_top).offset(3);
            
        }];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_detailBgView);
            make.width.offset(30);
            make.centerX.equalTo(_detailBgView.mas_left);
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_detailBgView);
            make.width.offset(30);
            make.centerX.equalTo(_detailBgView.mas_right);
        }];
        

    }
    return _detailBgView;
}
- (UIImageView *)detailImgView{
    if (!_detailImgView) {
        _detailImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_image"]];
        
    }
    return _detailImgView;
}
- (UILabel *)naviTitleLabel{
    if (!_naviTitleLabel) {
        _naviTitleLabel = [[UILabel alloc]init];
        _naviTitleLabel.text = @"菜品详情";
        _naviTitleLabel.font =  CYDefaultTextFont(18);
        _naviTitleLabel.textColor = [UIColor whiteColor];
    }
    return _naviTitleLabel;
}
- (MenuInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[MenuInfoView alloc]init];
        _infoView.menuModel = self.menuModel;
    }
    return _infoView;
}
@end
