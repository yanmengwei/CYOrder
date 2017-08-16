//
//  BaseViewController.m
//  CYOrder
//
//  Created by ymw on 17/4/12.
//  Copyright © 2017年 ymw. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()
{
    BOOL _isLeft;
    BOOL _isRight;
}
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _db = [DataBase shareDataBase];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)asd{

}
- (void)configSubviews{
    __weak UIView *superview = self.view;
    
    [superview addSubview:self.topBgImgView];
    [superview addSubview:self.bottomBgImgView];
    [superview addSubview:self.titleLabel];
    [superview addSubview:self.logoView];

    //背景图
    [self.topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.mas_equalTo(20);
        make.height.offset(93);
    }];
    [self.bottomBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superview);
        make.top.equalTo(self.topBgImgView.mas_bottom);
    }];
    //标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(300);
        make.centerX.equalTo(superview);
        make.height.offset(48);
        make.top.offset(20);
        
    }];
    //logo
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top);
        make.left.offset(24);
        make.width.offset(110);
        make.height.equalTo(self.titleLabel.mas_height);
    }];
}
#pragma mark -
- (void)showLeftView{
    __weak UIView *superview = self.view;
    [superview addSubview:self.leftBtn];
    [superview addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview.mas_left);
        make.centerY.equalTo(superview);
        make.width.offset(75);
        make.height.offset(270);
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right);
        make.height.offset(60);
        make.centerY.equalTo(self.leftView);
        make.width.offset(32);
    }];
}

- (void)closeViews{
    _isRight = NO;
    _isLeft = NO;
    [self changeLeftStatus];


}
#pragma mark - event
- (void)didClickLeftBtn:(UIButton *)sender{
    _isLeft = !_isLeft;
    [self changeLeftStatus];
}
- (void)didClickRightBtn:(UIButton *)sender{
    _isRight = !_isRight;

}
- (void)changeLeftStatus{
    __weak UIView *superview = self.view;
    if (_isLeft) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superview.mas_left);
                make.centerY.equalTo(superview);
                make.width.offset(75);
                make.height.offset(270);
                
            }];
            [superview layoutIfNeeded];
            
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(superview.mas_left);
                make.centerY.equalTo(superview);
                make.width.offset(75);
                make.height.offset(270);
                
            }];
            [superview layoutIfNeeded];
        }];
    }
}

- (void)leftDrawerView:(LeftDrawerView *)leftView didSelectAtIndex:(NSInteger)index{
    if ([leftView isEqual:self.leftView]) {
        NSLog(@"点击了服务");
    }else{
        
        NSLog(@"点击了套餐");
    }
}
#pragma mark - init
- (UIImageView *)topBgImgView{
    if (!_topBgImgView) {
        _topBgImgView = [[UIImageView alloc]init];
        [_topBgImgView setImage:[UIImage imageNamed:@"bar_bg"]];
        
    }
    return _topBgImgView;
}
- (UIImageView *)bottomBgImgView{
    if (!_bottomBgImgView) {
        _bottomBgImgView = [[UIImageView alloc]init];
        [_bottomBgImgView setImage:[UIImage imageNamed:@"bg"]];
    }
    return _bottomBgImgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"长娱点餐 V1.0 版"];
        
        [attrStr addAttribute:NSFontAttributeName value:CYDefaultTextFont(19) range:NSMakeRange(0,attrStr.length - 6)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:15] range:NSMakeRange(attrStr.length-6,6)];
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:50];//调整行间距
        
//        [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length]-6)];
        _titleLabel.attributedText = attrStr;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        
    }
    return _titleLabel;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]init];
        [_leftBtn addTarget:self action:@selector(didClickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setImage:[UIImage imageNamed:@"left_btn"] forState:UIControlStateNormal];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setImage:[UIImage imageNamed:@"package_btn"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}
- (LeftDrawerView *)leftView{
    if (!_leftView ) {
        _leftView = [[LeftDrawerView alloc]initLeftViewWithTitles:@[@"1",@"2",@"3",@"4",@"5"]];
        _leftView.delegate = self;
    }
    return _leftView;
}

- (UIImageView *)logoView{
    if (_logoView == nil) {
        _logoView = [[UIImageView alloc]init];
        [_logoView setImage:[UIImage imageNamed:@"logo"]];
    }
    return _logoView;
}
@end
